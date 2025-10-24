import '../model/interested_category.dart';

class AutomaticallyGenerateByAiState {
  final bool isLoading;
  final String? error;
  final int? itineraryId;
  final Set<InterestCategory> selectedInterests;
  final int step;
  final int maxSelection;

  // New fields for form inputs
  final int groupSize;
  final double budget;
  final String? specialRequirements;
  // Whether server response included generated data
  final bool isGenerated;
  // UI currency selection and derived converted value (USD -> VND)
  final String currency;
  final String? convertedVnd;

  AutomaticallyGenerateByAiState({
    this.isLoading = false,
    this.error,
    this.itineraryId,
    this.selectedInterests = const {},
    this.step = 0,

    this.maxSelection = 3,
    this.groupSize = 1,
    this.budget = 0.0,
    this.specialRequirements,
    this.isGenerated = false,
    this.currency = 'VND',
    this.convertedVnd,
  });

  AutomaticallyGenerateByAiState copyWith({
    final bool? isLoading,
    final String? error,
    final int? itineraryId,
    final Set<InterestCategory>? selectedInterests,
    final int? step,
    final int? maxSelection,
    final int? groupSize,
    final double? budget,
    final String? specialRequirements,
    final bool? isGenerated,
    final String? currency,
    final String? convertedVnd,
    final bool clearConvertedVnd =
        false, // Add flag to explicitly clear convertedVnd
  }) {
    return AutomaticallyGenerateByAiState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      itineraryId: itineraryId ?? this.itineraryId,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      step: step ?? this.step,
      maxSelection: maxSelection ?? this.maxSelection,
      groupSize: groupSize ?? this.groupSize,
      budget: budget ?? this.budget,
      specialRequirements: specialRequirements ?? this.specialRequirements,
      isGenerated: isGenerated ?? this.isGenerated,
      currency: currency ?? this.currency,
      convertedVnd: clearConvertedVnd
          ? null
          : (convertedVnd ?? this.convertedVnd),
    );
  }
}
