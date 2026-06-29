class SlaPolicy {
  final int? slaPolicyId;
  final String name;
  final String priorityLevel;
  final String? description;
  final bool escalateEnabled;
  final int escalationMinutes;
  final int responseMinutes;
  final int resolutionMinutes;
  final bool isActive;

  SlaPolicy({
    this.slaPolicyId,
    required this.name,
    required this.priorityLevel,
    this.description,
    required this.escalateEnabled,
    required this.escalationMinutes,
    required this.responseMinutes,
    required this.resolutionMinutes,
    required this.isActive,
  });

  factory SlaPolicy.fromJson(Map<String, dynamic> json) {
    return SlaPolicy(
      slaPolicyId: json["slaPolicyId"],
      name: json["name"] ?? "",
      priorityLevel: json["priorityLevel"] ?? "LOW",
      description: json["description"],
      escalateEnabled: json["escalateEnabled"] ?? false,
      escalationMinutes: json["escalationMinutes"] ?? 0,
      responseMinutes: json["responseMinutes"] ?? 0,
      resolutionMinutes: json["resolutionMinutes"] ?? 0,
      isActive: json["isActive"] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "priorityLevel": priorityLevel,
      "description": description,
      "escalateEnabled": escalateEnabled,
      "escalationMinutes": escalationMinutes,
      "responseMinutes": responseMinutes,
      "resolutionMinutes": resolutionMinutes,
      "isActive": isActive,
    };
  }
}
