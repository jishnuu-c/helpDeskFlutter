class Department {
  final int departmentId;
  final String name;
  final String description;
  final bool isActive;

  Department({
    required this.departmentId,
    required this.name,
    required this.description,
    required this.isActive,
  });

  factory Department.fromJson(
    Map<String, dynamic> json,
  ) {
    return Department(
      departmentId:
          json['departmentId'] ??
          json['id'] ??
          0,

      name:
          json['name'] ?? '',

      description:
          json['description'] ?? '',

      isActive:
          json['isActive'] ?? true,
    );
  }
}