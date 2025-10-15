class Province {
  final String id;
  final String name;

  Province({required this.id, required this.name});

  factory Province.fromJson(final Map<String, dynamic> json) {
    return Province(id: json['id'].toString(), name: json['name'] as String);
  }
}
