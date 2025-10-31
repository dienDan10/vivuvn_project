/// State for managing list section expand/collapse
class ListExpandState {
  final bool isExpanded;

  const ListExpandState({
    this.isExpanded = false,
  });

  ListExpandState copyWith({
    bool? isExpanded,
  }) {
    return ListExpandState(
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
