import 'dart:io';

import '../models/category_model.dart';
import '../models/department_model.dart';
import '../models/sla_policy_model.dart';
import '../models/user/user_model.dart';
import '../repository/ticket_repository.dart';

class TicketController {
  final TicketRepository repository =
      TicketRepository();

  Future<List<Department>>
      getDepartments() async {
    final data =
        await repository.getDepartments();

    return data
        .map<Department>(
          (e) =>
              Department.fromJson(e),
        )
        .toList();
  }

  Future<List<Category>>
      getCategories() async {
    final data =
        await repository.getCategories();

    return data
        .map<Category>(
          (e) =>
              Category.fromJson(e),
        )
        .toList();
  }

  Future<List<SlaPolicy>>
      getSlaPolicies() async {
    final data =
        await repository.getSlas();

    return data
        .map<SlaPolicy>(
          (e) =>
              SlaPolicy.fromJson(e),
        )
        .toList();
  }

  Future<void> createTicket({
    required Map<String, dynamic>
        payload,
    required List<File> files,
  }) {
    return repository.createTicket(
      payload: payload,
      files: files,
    );
  }

  Future<List<User>>
    getUsers() async {

  final data =
      await repository.getUsers();

  return data
      .map<User>(
        (e) =>
            User.fromJson(e),
      )
      .toList();
}

Future<void> createCategory(
    Map<String, dynamic> payload) {
  return repository.createCategory(
      payload);
}
}