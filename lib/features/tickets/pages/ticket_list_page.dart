import 'package:flutter/material.dart';

import '../services/ticket_service.dart';
import '../models/ticket_model.dart';
import 'create_ticket_page.dart';
import 'ticket_detail_page.dart';

class TicketListPage extends StatefulWidget {
  const TicketListPage({super.key});

  @override
  State<TicketListPage> createState() =>
      _TicketListPageState();
}

class _TicketListPageState
    extends State<TicketListPage> {
  final TicketService service =
      TicketService();

  List<Ticket> tickets = [];
  List<Ticket> filteredTickets = [];

  bool loading = true;

  final searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    setState(() {
      loading = true;
    });

    try {
      final response =
          await service.getTickets();

      tickets = response
          .map<Ticket>(
            (e) => Ticket.fromJson(e),
          )
          .toList();

      filteredTickets = tickets;
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      loading = false;
    });
  }

  void filterTickets(String value) {
    if (value.trim().isEmpty) {
      setState(() {
        filteredTickets = tickets;
      });
      return;
    }

    final term = value.toLowerCase();

    setState(() {
      filteredTickets = tickets.where((t) {
        return t.ticketNo
                .toLowerCase()
                .contains(term) ||
            t.subject
                .toLowerCase()
                .contains(term) ||
            t.description
                .toLowerCase()
                .contains(term);
      }).toList();
    });
  }

  Color priorityColor(String priority) {
    switch (priority) {
      case 'CRITICAL':
        return Colors.red;

      case 'HIGH':
        return Colors.orange;

      case 'MEDIUM':
        return Colors.amber;

      default:
        return Colors.green;
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case 'OPEN':
        return Colors.blue;

      case 'RESOLVED':
        return Colors.green;

      case 'CLOSED':
        return Colors.grey;

      default:
        return Colors.orange;
    }
  }

  bool isOverdue(Ticket ticket) {
    if (ticket.slaBreached) {
      return true;
    }

    if (ticket.slaDueAt == null) {
      return false;
    }

    return DateTime.parse(
          ticket.slaDueAt!,
        ).isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () async {
          final result =
              await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const CreateTicketPage(),
            ),
          );

          if (result == true) {
            fetchTickets();
          }
        },
        label: const Text(
          'Add Ticket',
        ),
        icon: const Icon(Icons.add),
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.all(
                          16),
                  child: TextField(
                    controller:
                        searchController,
                    onChanged:
                        filterTickets,
                    decoration:
                        InputDecoration(
                      hintText:
                          'Search by ticket no, subject or description',
                      prefixIcon:
                          const Icon(
                        Icons.search,
                      ),
                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                                    12),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child:
                      RefreshIndicator(
                    onRefresh:
                        fetchTickets,
                    child:
                        filteredTickets
                                .isEmpty
                            ? const Center(
                                child: Text(
                                  'No Tickets Found',
                                ),
                              )
                            : ListView.builder(
                                itemCount:
                                    filteredTickets
                                        .length,
                                itemBuilder:
                                    (
                                  context,
                                  index,
                                ) {
                                  final ticket =
                                      filteredTickets[
                                          index];

                                  return Container(
  margin: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  ),
  child: InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TicketDetailPage(
            ticketId: ticket.ticketId,
          ),
        ),
      );

      fetchTickets();
    },
                                    child:
                                        Card(
                                      elevation:
                                          3,
                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                          16,
                                        ),
                                      ),
                                      child:
                                          Padding(
                                        padding:
                                            const EdgeInsets.all(
                                          16,
                                        ),
                                        child:
                                            Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  ticket.ticketNo,
                                                  style:
                                                      const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize:
                                                        16,
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                    horizontal:
                                                        10,
                                                    vertical:
                                                        5,
                                                  ),
                                                  decoration:
                                                      BoxDecoration(
                                                    color:
                                                        priorityColor(ticket.priority),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20,
                                                    ),
                                                  ),
                                                  child:
                                                      Text(
                                                    ticket.priority,
                                                    style:
                                                        const TextStyle(
                                                      color:
                                                          Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),

                                            const SizedBox(
                                              height:
                                                  12,
                                            ),

                                            Text(
                                              ticket
                                                  .subject,
                                              style:
                                                  const TextStyle(
                                                fontWeight:
                                                    FontWeight.bold,
                                                fontSize:
                                                    18,
                                              ),
                                            ),

                                            const SizedBox(
                                              height:
                                                  8,
                                            ),

                                            Text(
                                              ticket
                                                  .description,
                                            ),

                                            const Divider(
                                              height:
                                                  25,
                                            ),

                                            Row(
                                              children: [
                                                const Text(
                                                  'Status : ',
                                                  style:
                                                      TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                    horizontal:
                                                        8,
                                                    vertical:
                                                        4,
                                                  ),
                                                  decoration:
                                                      BoxDecoration(
                                                    color:
                                                        statusColor(ticket.status),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20,
                                                    ),
                                                  ),
                                                  child:
                                                      Text(
                                                    ticket.status,
                                                    style:
                                                        const TextStyle(
                                                      color:
                                                          Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(
                                              height:
                                                  10,
                                            ),

                                            Text(
                                              "Channel : ${ticket.channel}",
                                            ),

                                            const SizedBox(
                                              height:
                                                  10,
                                            ),

                                            Text(
                                              "Attachments : ${ticket.attachments.length}",
                                            ),

                                            const SizedBox(
                                              height:
                                                  10,
                                            ),

                                            if (ticket
                                                    .slaDueAt !=
                                                null)
                                              Row(
                                                children: [
                                                  const Text(
                                                    'SLA : ',
                                                    style:
                                                        TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    ticket.slaDueAt!,
                                                    style:
                                                        TextStyle(
                                                      color: isOverdue(
                                                              ticket)
                                                          ? Colors.red
                                                          : Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  );
                                },
                              ),
                  ),
                ),
              ],
            ),
    );
  }
}