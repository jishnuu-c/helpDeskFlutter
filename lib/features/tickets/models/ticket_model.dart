class Ticket {
  final int ticketId;
  final String ticketNo;
  final String subject;
  final String description;
  final String priority;
  final String status;
  final String channel;

  final bool slaBreached;
  final String? slaDueAt;

  final int? reporterId;
  final int? assigneeId;
  final int? departmentId;
  final int? slaPolicyId;


  final String? firstResponseAt;
  final String? resolvedAt;
  final String? closedAt;

  final Map<String, dynamic>? category;

  final Map<String, dynamic>? assignee;
final Map<String, dynamic>? department;
final Map<String, dynamic>? slaPolicy;

  final List<dynamic> attachments;

  Ticket({
    required this.ticketId,
    required this.ticketNo,
    required this.subject,
    required this.description,
    required this.priority,
    required this.status,
    required this.channel,
    required this.slaBreached,
    required this.attachments,
    this.slaDueAt,
    this.reporterId,
    this.assigneeId,
    this.departmentId,
    this.slaPolicyId,
    this.firstResponseAt,
    this.resolvedAt,
    this.closedAt,
    this.category,
    this.assignee,
    this.department,
    this.slaPolicy,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      ticketId: json['ticketId'] ?? 0,
      ticketNo: json['ticketNo'] ?? '',
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      channel: json['channel'] ?? '',
      slaBreached: json['slaBreached'] ?? false,
      slaDueAt: json['slaDueAt'],

      reporterId: json['reporterId'],
      assigneeId: json['assigneeId'],
      departmentId: json['departmentId'],
      slaPolicyId: json['slaPolicyId'],

      firstResponseAt: json['firstResponseAt'],

      resolvedAt: json['resolvedAt'],

      closedAt: json['closedAt'],

      category: json['category'] != null
          ? Map<String, dynamic>.from(json['category'])
          : null,

      assignee: json['assignee'] != null
          ? Map<String, dynamic>.from(json['assignee'])
          : null,

      department: json['department'] != null
          ? Map<String, dynamic>.from(json['department'])
          : null,

      slaPolicy: json['slaPolicy'] != null
          ? Map<String, dynamic>.from(json['slaPolicy'])
          : null,

      attachments: json['attachments'] ?? [],
    );
  }
}
