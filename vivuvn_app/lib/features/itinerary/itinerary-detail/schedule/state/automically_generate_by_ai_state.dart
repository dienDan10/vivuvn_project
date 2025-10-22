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

  AutomaticallyGenerateByAiState({
    this.isLoading = false,
    this.error,
    this.itineraryId,
    this.selectedInterests = const {},
    this.step = 1,
    this.maxSelection = 3,
    this.groupSize = 1,
    this.budget = 0.0,
    this.specialRequirements,
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
    );
  }
}
