class ActivityLog {
  final String title;
  final String message;
  final String action;
  final String createdAt;
  final int? entityId;                    // ← PUTHUTHAYI ADD
  final String? performedByName;          // ← PUTHUTHAYI ADD

  ActivityLog({
    required this.title,
    required this.message,
    required this.action,
    required this.createdAt,
    this.entityId,
    this.performedByName,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      title: json["title"] ?? "",
      message: json["message"] ?? "",
      action: json["action"] ?? "",
      createdAt: json["createdAt"] ?? "",
      entityId: json["entityId"],                                    // ← PUTHUTHAYI ADD
      performedByName: json["performedBy"]?["fullName"] ?? "",       // ← PUTHUTHAYI ADD
    );
  }
}