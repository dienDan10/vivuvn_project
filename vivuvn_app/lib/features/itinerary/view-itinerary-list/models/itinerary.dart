class Itinerary {
  final String id;
  final String name;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;

  Itinerary({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
  });
}

final List<Itinerary> dummyItineraries = [
  Itinerary(
    id: '1',
    name: 'Trip to Paris',
    imageUrl:
        'https://plus.unsplash.com/premium_photo-1738856608580-23d0ab1632e4?q=80&w=1550&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    startDate: DateTime(2023, 10, 1),
    endDate: DateTime(2023, 10, 7),
  ),
  Itinerary(
    id: '2',
    name: 'Beach Vacation',
    imageUrl:
        'https://images.unsplash.com/photo-1759691397755-9f761d9615ec?q=80&w=1742&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    startDate: DateTime(2023, 11, 15),
    endDate: DateTime(2023, 11, 20),
  ),
  Itinerary(
    id: '3',
    name: 'Mountain Hiking',
    imageUrl:
        'https://images.unsplash.com/photo-1733169312700-a3dfad2d99f0?q=80&w=1742&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    startDate: DateTime(2024, 1, 5),
    endDate: DateTime(2024, 1, 12),
  ),
];
