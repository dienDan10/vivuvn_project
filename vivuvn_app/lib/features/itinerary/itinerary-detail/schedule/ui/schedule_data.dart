class Place {
  final String title;
  final String description;

  Place({required this.title, required this.description});
}

// Danh sách sample
final List<Place> samplePlaces = [
  Place(
    title: 'Bãi biển Mỹ Khê',
    description:
        'Bãi biển Mỹ Khê là một bãi biển đẹp, nằm trên trục chính từ Bắc vào Nam. Nước biển trong xanh, sóng đánh hiền hòa, cát trắng mịn...',
  ),
  Place(
    title: 'Cầu Rồng',
    description:
        'Cầu Rồng là cây cầu nổi tiếng bắc qua sông Hàn, có thể phun lửa và nước vào cuối tuần.',
  ),
  Place(
    title: 'Ngũ Hành Sơn',
    description:
        'Ngũ Hành Sơn là quần thể gồm 5 ngọn núi đá vôi nổi tiếng với các hang động và chùa chiền.',
  ),
];
