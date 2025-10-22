import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/automically_generate_by_ai.dart';
import '../data/dto/generate_itinerary_by_ai_request.dart';
import '../model/interested_category.dart';
import '../state/automically_generate_by_ai_state.dart';
import 'itinerary_schedule_controller.dart';

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
      itineraryScheduleControllerProvider.select((final s) => s.itineraryId),
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

  void setBudget(final double budget) {
    state = state.copyWith(budget: budget);
  }

  void setSpecialRequirements(final String? note) {
    state = state.copyWith(specialRequirements: note);
  }

  void nextStep() {
    state = state.copyWith(step: state.step + 1);
  }

  void prevStep() {
    state = state.copyWith(step: state.step - 1);
  }

  Future<void> submitGenerate() async {
    state = state.copyWith(isLoading: true, error: null);

    int? itineraryId = state.itineraryId;
    itineraryId ??= ref.read(
      itineraryScheduleControllerProvider.select((final s) => s.itineraryId),
    );

    if (itineraryId == null) {
      state = state.copyWith(
        isLoading: false,
        error:
            'Itinerary ID not found. Please open this from an itinerary context.',
      );
      return;
    }

    try {
      final api = ref.read(automaticallyGenerateByAiProvider);
      final request = GenerateItineraryByAiRequest(
        itineraryId: itineraryId,
        preferences: state.selectedInterests.map((final e) => e.name).toList(),
        groupSize: state.groupSize,
        budget: state.budget,
        specialRequirements: state.specialRequirements,
      );
      await api.generateItineraryByAi(
        itineraryId: itineraryId,
        request: request,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
