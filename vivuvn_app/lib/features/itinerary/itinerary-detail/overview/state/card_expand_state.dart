/// State for managing individual card expand/collapse
class CardExpandState {
  final Map<String, bool> expandedCards;

  const CardExpandState({
    this.expandedCards = const {},
  });

  CardExpandState copyWith({
    Map<String, bool>? expandedCards,
  }) {
    return CardExpandState(
      expandedCards: expandedCards ?? this.expandedCards,
    );
  }

  bool isExpanded(String cardId) => expandedCards[cardId] ?? false;
}
