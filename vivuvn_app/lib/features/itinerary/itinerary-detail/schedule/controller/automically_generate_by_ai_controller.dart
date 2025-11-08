import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/validator/validation_exception.dart';
import '../../../../../common/validator/validator.dart';
import '../../../../../core/data/remote/exception/dio_exception_handler.dart';
import '../../detail/controller/itinerary_detail_controller.dart';
import '../data/api/automically_generate_by_ai_api.dart';
import '../data/dto/generate_itinerary_by_ai_request.dart';
import '../model/interested_category.dart';
import '../state/automically_generate_by_ai_state.dart';
import 'validate_and_submit_result.dart';

// Provider used to request a tab switch from the AI modal flow. When the
// controller completes generation successfully it will set this to the target
// tab index (e.g. 0 for overview). UI that owns the TabController should
// listen to this provider and perform the animateTo call.
final aiTabSwitchProvider = StateProvider<int?>((final ref) => null);

final automicallyGenerateByAiControllerProvider =
    AutoDisposeNotifierProvider<
      AutomaticallyGenerateByAiController,
      AutomaticallyGenerateByAiState
    >(() => AutomaticallyGenerateByAiController());

class AutomaticallyGenerateByAiController
    extends AutoDisposeNotifier<AutomaticallyGenerateByAiState> {
  @override
  AutomaticallyGenerateByAiState build() {
    return AutomaticallyGenerateByAiState();
  }

  void attachToParent() {
    final int? itineraryId = ref.read(
      itineraryDetailControllerProvider.select((final s) => s.itineraryId),
    );

    if (itineraryId != null) {
      state = state.copyWith(itineraryId: itineraryId);
    }
  }

  void toggleInterest(final InterestCategory interest) {
    final current = state;
    final set = Set<InterestCategory>.from(current.selectedInterests);
    if (set.contains(interest)) {
      set.remove(interest);
    } else {
      if (set.length < current.maxSelection) set.add(interest);
    }
    state = state.copyWith(selectedInterests: set);
  }

  void setGroupSize(final int size) {
    state = state.copyWith(groupSize: size);
  }

  /// Parse a raw text input for group size and update state.
  ///
  /// Empty or invalid input will set groupSize to 0 to avoid stale state.
  void setGroupSizeFromString(final String raw) {
    final text = raw.trim();
    if (text.isEmpty) {
      setGroupSize(0);
      return;
    }
    final n = int.tryParse(text);
    if (n != null && n >= 0) {
      setGroupSize(n);
    } else {
      setGroupSize(0);
    }
  }

  /// Format group size for display in the TextField.
  /// Returns empty string when groupSize is 0.
  String formatGroupSize(final int size) {
    if (size <= 0) return '';
    return size.toString();
  }

  void setBudget(final double budget) {
    state = state.copyWith(budget: budget);
    // Recompute convertedVnd whenever budget changes
    _recomputeConvertedVnd(state.currency, budget);
  }

  /// Parse a raw text input (possibly from a TextField) and update budget.
  ///
  /// This centralizes parsing/validation so widgets remain presentation-only.
  void setBudgetFromString(final String raw) {
    final text = raw.trim();
    if (text.isEmpty) {
      setBudget(0.0);
      return;
    }
    final sanitized = text.replaceAll(RegExp(r'[\s,]'), '');
    if (sanitized.isEmpty) {
      setBudget(0.0);
      return;
    }
    final value = double.tryParse(sanitized);
    if (value != null && value > 0) {
      setBudget(value);
    } else {
      setBudget(0.0);
    }
  }

  /// Format a numeric budget value for display.
  ///
  /// Returns an integer string if there's no fractional part, otherwise trims
  /// trailing zeros (e.g. 8.0 -> "8", 8.500 -> "8.5").
  String formatBudget(final double value) {
    if (value % 1 == 0) return value.toInt().toString();
    var text = value.toString();
    if (text.contains('.') && text.endsWith('0')) {
      text = text.replaceFirst(RegExp(r'0+$'), '');
      if (text.endsWith('.')) text = text.substring(0, text.length - 1);
    }
    return text;
  }

  void setSpecialRequirements(final String? note) {
    state = state.copyWith(specialRequirements: note);
  }

  void setTransportationMode(final String? mode) {
    state = state.copyWith(transportationMode: mode);
  }

  void setCurrency(final String currency) {
    state = state.copyWith(currency: currency);
    _recomputeConvertedVnd(currency, state.budget);
  }

  void _recomputeConvertedVnd(final String currency, final double budget) {
    if (currency != 'USD' || budget <= 0) {
      state = state.copyWith(clearConvertedVnd: true);
      return;
    }
    const double usdToVndRate = 24000;
    final vnd = (budget * usdToVndRate).round();
    final formatted = _formatVnd(vnd);
    state = state.copyWith(convertedVnd: formatted);
  }

  String _formatVnd(final int value) {
    final s = value.toString();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(reg, (final m) => ',');
  }

  void nextStep() {
    state = state.copyWith(step: state.step + 1);
  }

  void prevStep() {
    state = state.copyWith(step: state.step - 1);
  }

  Future<void> submitGenerate() async {
    state = state.copyWith(isLoading: true, error: null, isGenerated: false);

    final int itineraryId = state.itineraryId!;

    final api = ref.read(automaticallyGenerateByAiProvider);
    try {
      double budgetToSend = state.budget;
      if (state.currency == 'USD' && state.budget > 0) {
        const double usdToVndRate = 24000;
        final vnd = (state.budget * usdToVndRate).round();
        budgetToSend = vnd.toDouble();
      }

      final request = GenerateItineraryByAiRequest(
        itineraryId: itineraryId,
        preferences: state.selectedInterests.map((final e) => e.vNameseName).toList(),
        groupSize: state.groupSize,
        budget: budgetToSend,
        specialRequirements: state.specialRequirements,
        transportationMode: state.transportationMode,
      );
      await api.generateItineraryByAi(request: request);
      state = state.copyWith(isGenerated: true);
    } on DioException catch (e) {
      state = state.copyWith(error: DioExceptionHandler.handleException(e));
    } on ValidationException catch (e) {
      state = state.copyWith(error: e.toString());
    } on Exception catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Return a validation error message for the current group's size, or null
  /// when valid. Keeps validation logic centralized in the controller.
  String? validateGroupSize() {
    return Validator.validateGroupSize(state.groupSize.toString());
  }

  /// Return a validation error message for the current budget (respecting
  /// selected currency), or null when valid.
  String? validateBudget() {
    return Validator.validateBudget(
      state.budget.toString(),
      currency: state.currency,
    );
  }

  /// Return a validation error message for transportation mode, or null when valid.
  String? validateTransportationMode() {
    if (state.transportationMode == null || state.transportationMode!.isEmpty) {
      return 'Vui lòng chọn phương tiện di chuyển';
    }
    return null;
  }

  /// Validate current step and, if it's the final step, submit the request.
  ///
  /// Returns a [ValidateAndSubmitResult] describing whether the UI should
  /// advance to the next step, or whether a submission was attempted and its
  /// outcome.
  Future<ValidateAndSubmitResult> validateAndSubmit() async {
    const int lastStep = 2;
    final int step = state.step;

    // Step 1: budget and transportation mode validation
    if (step == 1) {
      final budgetErr = validateBudget();
      if (budgetErr != null) return ValidateAndSubmitResult.validationError(budgetErr);
      final transportErr = validateTransportationMode();
      if (transportErr != null) return ValidateAndSubmitResult.validationError(transportErr);
      return ValidateAndSubmitResult.advance();
    }

    // Step 2 (last): validate group size then submit
    if (step == lastStep) {
      final gerr = validateGroupSize();
      if (gerr != null) return ValidateAndSubmitResult.validationError(gerr);

      // perform submission
      await submitGenerate();

      if (state.isGenerated) {
        // Request UI to switch to overview tab (index 0)
        ref.read(aiTabSwitchProvider.notifier).state = 0;
        return ValidateAndSubmitResult.submittedSuccess();
      }
      return ValidateAndSubmitResult.submittedError(
        state.error ?? 'Không thể tạo lịch trình',
      );
    }

    // Step 0 or other: nothing to validate, instruct UI to advance
    return ValidateAndSubmitResult.advance();
  }
}
