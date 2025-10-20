// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Province {
  final int id;
  final String name;

  Province({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name};
  }

  factory Province.fromMap(final Map<String, dynamic> map) {
    return Province(id: map['id'] as int, name: map['name'] as String);
  }

  String toJson() => json.encode(toMap());

  factory Province.fromJson(final String source) =>
      Province.fromMap(json.decode(source) as Map<String, dynamic>);
}
