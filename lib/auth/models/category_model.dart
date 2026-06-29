class Category {
  final int categoryId;
  final String name;
  final String description;
  final int? parentId;

  Category({
    required this.categoryId,
    required this.name,
    required this.description,
    this.parentId,
  });

  factory Category.fromJson(
    Map<String, dynamic> json,
  ) {
    return Category(
      categoryId: json['categoryId'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      parentId:
          json['parentCategory'] == null
              ? null
              : json['parentCategory']
                  ['categoryId'],
    );
  }
}