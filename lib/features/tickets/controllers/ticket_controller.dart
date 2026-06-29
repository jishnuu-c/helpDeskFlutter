import 'dart:io';

import '../repositories/ticket_repository.dart';

class TicketController {
  final TicketRepository repository = TicketRepository();

  Future<void> createTicket({
    required Map<String, dynamic> payload,
    required List<File> files,
  }) {
    return repository.createTicket(
      payload: payload,
      files: files,
    );
  }
}