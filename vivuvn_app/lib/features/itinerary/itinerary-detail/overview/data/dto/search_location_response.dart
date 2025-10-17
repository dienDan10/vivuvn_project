class SearchLocationResponse {
  final int id;
  final String name;
  final String address;
  final String? provinceName;

  SearchLocationResponse({
    required this.id,
    required this.name,
    required this.address,
    this.provinceName,
  });

  factory SearchLocationResponse.fromJson(final Map<String, dynamic> json) {
    return SearchLocationResponse(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      provinceName: json['provinceName'] as String?,
    );
  }
}
