class FirstAidCategory {
  final String id;
  final String name;

  const FirstAidCategory({
    required this.id,
    required this.name,
  });

  factory FirstAidCategory.fromJson(Map<String, dynamic> json) {
    return FirstAidCategory(
      id: json['id'].toString(),
      name: json['name'] ?? '',
    );
  }
}