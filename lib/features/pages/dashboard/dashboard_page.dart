import 'package:flutter/material.dart';
import '../tickets/create_ticket_page.dart';
import '../tickets/ticket_detail_page.dart';
import '../../../services/ticket_service.dart';

Color getActivityDotColor(String action) {
  switch (action.toUpperCase()) {
    case "CREATED":
      return Colors.green;
    case "ASSIGNED":
      return Colors.blue;
    case "UPDATED":
      return Colors.purple;
    case "RESOLVED":
      return Colors.green;
    case "CLOSED":
      return Colors.orange;
    case "ESCALATED":
      return Colors.red;
    default:
      return Colors.blue;
  }
}

IconData getActivityIcon(String action) {
  switch (action.toUpperCase()) {
    case "CREATED":
      return Icons.add_circle_outline;
    case "ASSIGNED":
      return Icons.person_add;
    case "UPDATED":
      return Icons.edit;
    case "RESOLVED":
      return Icons.check_circle;
    case "CLOSED":
      return Icons.cancel;
    case "ESCALATED":
      return Icons.warning;
    default:
      return Icons.info;
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TicketService service = TicketService();

  List tickets = [];
  List logs = [];
  List agentWorkload = [];

  bool loadingLogs = false;
  bool loadingWorkload = false;
  List filteredTickets = [];
  bool loading = true;

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTickets();
    loadLogs();
    loadAgentWorkload();
  }

  Future loadTickets() async {
    try {
      tickets = await service.getTickets();
      filteredTickets = List.from(tickets);
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  Future loadLogs() async {
    setState(() => loadingLogs = true);
    try {
      logs = await service.getLogs();
    } catch (e) {}
    setState(() => loadingLogs = false);
  }

  Future loadAgentWorkload() async {
    setState(() => loadingWorkload = true);
    try {
      agentWorkload = await service.getAgentWorkload();
    } catch (e) {}
    setState(() => loadingWorkload = false);
  }

  void search(String value) {
    setState(() {
      filteredTickets = tickets.where((ticket) {
        return ticket["subject"].toString().toLowerCase().contains(
          value.toLowerCase(),
        );
      }).toList();
    });
  }

  int get openTickets => tickets.where((e) => e["status"] == "OPEN").length;
  int get resolvedTickets =>
      tickets.where((e) => e["status"] == "RESOLVED").length;
  int get breached => tickets.where((e) => e["slaBreached"] == true).length;

  Color priorityColor(String value) {
    switch (value.toUpperCase()) {
      case "CRITICAL":
        return Colors.red;
      case "HIGH":
        return Colors.orange;
      case "MEDIUM":
        return Colors.amber;
      default:
        return Colors.green;
    }
  }

  Color statusColor(String value) {
    switch (value.toUpperCase()) {
      case "OPEN":
        return Colors.blue;
      case "RESOLVED":
        return Colors.green;
      case "CLOSED":
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.length >= 2
        ? name.substring(0, 2).toUpperCase()
        : name.toUpperCase();
  }

  double getWorkloadPercent(dynamic agent) {
    final percent = agent["workloadPercentage"] ?? 0;
    return (percent / 100.0).clamp(0.0, 1.0);
  }

  Color getWorkloadColor(double percent) {
    if (percent >= 0.8) return Colors.red;
    if (percent >= 0.5) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xfff5f7fa),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateTicketPage()),
              );
              loadTickets(); // ticket create cheythal list refresh aavum
            },
            icon: const Icon(Icons.add),
            label: const Text("New Ticket"),
          ),
          const SizedBox(width: 15),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// SEARCH
            TextField(
              controller: searchController,
              onChanged: search,
              decoration: InputDecoration(
                hintText: "Search tickets",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// STATS
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                statCard("Open", openTickets.toString(), Colors.blue),
                statCard("Resolved", resolvedTickets.toString(), Colors.green),
                statCard("SLA", breached.toString(), Colors.red),
                statCard("Total", tickets.length.toString(), Colors.orange),
              ],
            ),

            const SizedBox(height: 20),

            /// RECENT TICKETS TITLE
            Row(
              children: const [
                Text(
                  "Recent Tickets",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// RECENT TICKETS LIST
            filteredTickets.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(Icons.inbox, size: 60, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            "No tickets found",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    height: 400,
                    child: ListView.builder(
                      itemCount: filteredTickets.length,
                      itemBuilder: (context, index) {
                        final ticket = filteredTickets[index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TicketDetailPage(
                                  ticketId: ticket["ticketId"],
                                ),
                              ),
                            );
                            loadTickets();
                          },
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        ticket["ticketNo"],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Chip(
                                        backgroundColor: priorityColor(
                                          ticket["priority"],
                                        ),
                                        label: Text(ticket["priority"]),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    ticket["subject"],
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    ticket["description"] ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: statusColor(ticket["status"]),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          ticket["status"],
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        width: 80,
                                        child: LinearProgressIndicator(
                                          value: ticket["slaBreached"] == true
                                              ? 1
                                              : 0.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

            const SizedBox(height: 20),

            /// RECENT ACTIVITY
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Recent Activity",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    if (loadingLogs)
                      const Center(child: CircularProgressIndicator())
                    else if (logs.isEmpty)
                      const Text(
                        "No activity yet",
                        style: TextStyle(color: Colors.grey),
                      )
                    else
                      SizedBox(
                        height: 400,
                        child: ListView.builder(
                          itemCount: logs.length,
                          itemBuilder: (context, index) {
                            final log = logs[index];
                            final action = log["action"] ?? "";
                            final performedBy =
                                log["performedBy"]?["fullName"] ?? "Unknown";
                            final entityId = log["entityId"]?.toString() ?? "";
                            final title = log["title"] ?? "";
                            final message = log["message"] ?? "";
                            final createdAt = log["createdAt"] ?? "";

                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: getActivityDotColor(action),
                                child: Icon(
                                  getActivityIcon(action),
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              title: Text(
                                "$title — Ticket #$entityId",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(message),
                                  Text(
                                    "by $performedBy · $createdAt",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// AGENT WORKLOAD
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Agent Workload",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    if (loadingWorkload)
                      const Center(child: CircularProgressIndicator())
                    else if (agentWorkload.isEmpty)
                      const Text(
                        "No agents found",
                        style: TextStyle(color: Colors.grey),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: agentWorkload.length,
                        itemBuilder: (context, index) {
                          final agent = agentWorkload[index];
                          final name = agent["agentName"] ?? "Unknown";
                          final activeTickets = agent["activeTicketCount"] ?? 0;
                          final initials = getInitials(name);
                          final percent = getWorkloadPercent(agent);
                          final color = getWorkloadColor(percent);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: color.withOpacity(0.2),
                                  child: Text(
                                    initials,
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "$activeTickets active tickets",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: percent,
                                          minHeight: 6,
                                          backgroundColor: Colors.grey.shade200,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                color,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "${agent["workloadPercentage"] ?? 0}%",
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statCard(String title, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics, size: 35, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
