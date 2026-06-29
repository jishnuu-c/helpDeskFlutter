import 'dart:io';

import '../models/ticket_model.dart';
import '../repositories/ticket_repository.dart';

class TicketService {
  final TicketRepository repository = TicketRepository();

  Future<List<dynamic>> getTickets() {
    return repository.getTickets();
  }

  Future<List<dynamic>> getLogs() {
    return repository.getLogs();
  }

  Future<List<dynamic>> getAgentWorkload() {
    return repository.getAgentWorkload();
  }

  Future<void> assignAgent(int ticketId, int userId) {
    return repository.assignAgent(ticketId, userId);
  }

  Future<void> updateStatus(
    int ticketId,
    String oldStatus,
    String newStatus,
    String reason,
  ) {
    return repository.updateStatus(ticketId, oldStatus, newStatus, reason);
  }

  Future<Ticket> getTicketById(int id) async {
    final response = await repository.getTicketById(id);
    return Ticket.fromJson(response);
  }

  Future<List<dynamic>> getComments(int ticketId) {
    return repository.getComments(ticketId);
  }

  Future<void> addComment({
    required int ticketId,
    required String text,
    required List<File> files,
  }) {
    return repository.addComment(ticketId: ticketId, text: text, files: files);
  }

  Future<void> deleteComment(int commentId) {
    return repository.deleteComment(commentId);
  }

  Future<void> deleteAttachment(int attachmentId) {
    return repository.deleteAttachment(attachmentId);
  }
}
