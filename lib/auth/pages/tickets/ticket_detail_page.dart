import 'dart:io';

import 'package:flutter/material.dart';
import 'package:help_desk_flutter/core/network/api_endpoints.dart';
import 'package:help_desk_flutter/core/storage/token_storage.dart';

import '../../../service/ticket_service.dart';
import '../../models/tickets/ticket_model.dart';
import 'package:file_picker/file_picker.dart';

class TicketDetailPage extends StatefulWidget {
  final int ticketId;

  const TicketDetailPage({super.key, required this.ticketId});

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

final TicketService ticketService = TicketService();

class _TicketDetailPageState extends State<TicketDetailPage> {
  final TicketService service = TicketService();

  Ticket? ticket;

  List<dynamic> comments = [];

  bool loading = true;

  final TextEditingController commentController = TextEditingController();

  List<File> files = [];
  String? token;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      token = await TokenStorage.getToken();

      final ticketData = await service.getTicketById(widget.ticketId);

      final commentData = await service.getComments(widget.ticketId);
      print(commentData);

      setState(() {
        ticket = ticketData;
        comments = commentData;
        loading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        files.addAll(
          result.paths.where((path) => path != null).map((path) => File(path!)),
        );
      });
    }
  }

  void showAssignDialog(Ticket ticket) async {
    final users = await ticketService.fetchStaffs();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (_, index) {
            final user = users[index];

            return ListTile(
              title: Text(user["fullName"]),
              subtitle: Text(user["email"]),
              onTap: () async {
                await ticketService.assignAgent(ticket.ticketId, user["id"]);

                Navigator.pop(context);

                await loadData();
              },
            );
          },
        );
      },
    );
  }

  void showStatusDialog(Ticket ticket, String status) {
    TextEditingController reason = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Reason"),

          content: TextField(controller: reason, maxLines: 3),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                await ticketService.updateStatus(
                  ticket.ticketId,
                  ticket.status,
                  status,
                  reason.text,
                );

                Navigator.pop(context);

                await loadData();
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  Future<void> submitComment() async {
    if (commentController.text.trim().isEmpty && files.isEmpty) {
      return;
    }

    try {
      print(commentController.text);

      for (var file in files) {
        print(file.path);
      }

      await service.addComment(
        ticketId: widget.ticketId,
        text: commentController.text,
        files: files,
      );

      commentController.clear();

      setState(() {
        files.clear();
      });

      await loadData();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));

      setState(() {
        loading = false;
      });
    }
  }

  Color priorityColor(String value) {
    switch (value.toUpperCase()) {
      case "HIGH":
        return Colors.orange;
      case "CRITICAL":
        return Colors.red;
      case "MEDIUM":
        return Colors.amber;
      default:
        return Colors.blue;
    }
  }

  Color statusColor(String value) {
    switch (value.toUpperCase()) {
      case "OPEN":
        return Colors.green;
      case "RESOLVED":
        return Colors.blue;
      case "CLOSED":
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xfff5f7fa),
      appBar: AppBar(title: Text(ticket?.ticketNo ?? "")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(ticket?.ticketNo ?? ""),
                ),

                Chip(
                  label: Text(ticket?.priority ?? ""),
                  backgroundColor: priorityColor(ticket?.priority ?? ""),
                ),

                Chip(
                  label: Text(ticket?.status ?? ""),
                  backgroundColor: statusColor(ticket?.status ?? ""),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              ticket?.subject ?? "",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            detailCard("Description", ticket?.description ?? ""),

            detailCard(
              "Category",
              ticket?.category?["name"] ?? "",
              subtitle: ticket?.category?["description"] ?? "",
            ),

            detailCard(
              "SLA Due",
              ticket?.slaDueAt ?? "-",
              subtitle: ticket?.slaBreached == true
                  ? "SLA Breached"
                  : "Within SLA",
            ),

            detailCard("Reporter", ticket?.reporterId?.toString() ?? "-"),

            detailCard("Assignee", ticket?.assigneeId?.toString() ?? "-"),

            detailCard("Department", ticket?.departmentId?.toString() ?? "-"),

            detailCard("SLA Policy", ticket?.slaPolicyId?.toString() ?? "-"),

            detailCard("First Response", ticket?.firstResponseAt ?? "Pending"),

            detailCard("Resolved", ticket?.resolvedAt ?? "Not Yet"),

            detailCard("Closed", ticket?.closedAt ?? "Not Yet"),

            const SizedBox(height: 25),

            Card(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Status",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    DropdownButton<String>(
                      value: ticket?.status,
                      items: const [
                        DropdownMenuItem(value: "OPEN", child: Text("OPEN")),

                        DropdownMenuItem(
                          value: "IN_PROGRESS",
                          child: Text("IN PROGRESS"),
                        ),

                        DropdownMenuItem(
                          value: "RESOLVED",
                          child: Text("RESOLVED"),
                        ),

                        DropdownMenuItem(
                          value: "CLOSED",
                          child: Text("CLOSED"),
                        ),
                      ],
                      onChanged: (value) {
                        if (ticket != null && value != null) {
                          showStatusDialog(ticket!, value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Card(
              child: ListTile(
                title: Text("Assignee"),
                subtitle: Text(ticket?.assignee?["fullName"] ?? "Unassigned"),
                trailing: Icon(Icons.edit),
                onTap: () {
                  if (ticket != null) {
                    showAssignDialog(ticket!);
                  }
                },
              ),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      const Text(
                        "Discussion",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text("${comments.length} Comments"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  if (comments.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Text("No comments yet"),
                      ),
                    ),

                  ...comments.map((comment) {
                    final author = comment["author"]?["fullName"] ?? "User";

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Text(
                              author.isNotEmpty ? author[0].toUpperCase() : "U",
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          author,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () async {
                                          await service.deleteComment(
                                            comment["commentId"],
                                          );

                                          await loadData();
                                        },
                                      ),
                                    ],
                                  ),

                                  Text(comment["body"] ?? ""),

                                  if (comment["attachments"] != null)
                                    ...((comment["attachments"] as List).map((
                                      attachment,
                                    ) {
                                      final fileUrl =
                                          attachment["fileUrl"] ?? "";
                                      print(fileUrl);

                                      final imageUrl = Uri.encodeFull(
                                        "${ApiEndpoints.fileBaseUrl}$fileUrl",
                                      );

                                      print(imageUrl);
                                      print("=========================");
                                      print("==========================");

                                      final isImage =
                                          fileUrl.toLowerCase().endsWith(
                                            ".png",
                                          ) ||
                                          fileUrl.toLowerCase().endsWith(
                                            ".jpg",
                                          ) ||
                                          fileUrl.toLowerCase().endsWith(
                                            ".jpeg",
                                          );

                                      return Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (isImage)
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  imageUrl,

                                                  headers: {
                                                    "Authorization":
                                                        "Bearer $token",
                                                  },

                                                  height: 150,
                                                  width: 220,
                                                  fit: BoxFit.cover,

                                                  errorBuilder:
                                                      (_, error, stackTrace) {
                                                        return const Icon(
                                                          Icons.broken_image,
                                                          size: 60,
                                                          color: Colors.red,
                                                        );
                                                      },
                                                ),
                                              ),

                                            const SizedBox(height: 8),

                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.blue.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.attach_file,
                                                    size: 16,
                                                    color: Colors.blue,
                                                  ),

                                                  const SizedBox(width: 5),

                                                  Flexible(
                                                    child: Text(
                                                      attachment["fileName"] ??
                                                          "Attachment",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    })),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: pickFiles,
                    icon: const Icon(Icons.attach_file),
                    label: const Text("Attach Files"),
                  ),

                  const SizedBox(height: 10),

                  if (files.isNotEmpty)
                    Column(
                      children: files.map((file) {
                        return ListTile(
                          leading: const Icon(Icons.insert_drive_file),
                          title: Text(file.path.split('/').last),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                files.remove(file);
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Add a comment",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: submitComment,
                      icon: const Icon(Icons.send),
                      label: const Text("Post Comment"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailCard(String title, String value, {String? subtitle}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),

            const SizedBox(height: 8),

            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),

            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
