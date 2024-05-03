class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  factory Category.fromJson(Map<String, dynamic> data, String id) {
    return Category(
      id: id,
      name: data['name'],
    );
  }
}
