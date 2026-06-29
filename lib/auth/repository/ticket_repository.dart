import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';

class TicketRepository {
  final dio = DioClient.dio;

  Future<List<dynamic>> getTickets() async {
    final response = await dio.get(
      ApiEndpoints.getTickets,
    );

    return response.data;
  }

  Future<dynamic> getTicketById(
    int id,
  ) async {
    final response = await dio.get(
      '${ApiEndpoints.getTicketById}/$id',
    );

    return response.data;
  }

  Future<List<dynamic>> getDepartments() async {
    final response = await dio.get(
      ApiEndpoints.departments,
    );

    return response.data;
  }

  Future<List<dynamic>> getCategories() async {
    final response = await dio.get(
      ApiEndpoints.categories,
    );

    return response.data;
  }

  Future<List<dynamic>> getSlas() async {
    final response = await dio.get(
      ApiEndpoints.getSlas,
    );


    return response.data;
  }
  
     Future<List<dynamic>> getUsers() async {
  final response =
      await dio.get(
          ApiEndpoints.users);

  return response.data;
}

Future<List<dynamic>> getLogs() async {
  final response = await dio.get(
    ApiEndpoints.getLogs,
  );
  return response.data;
}

Future<List<dynamic>> getAgentWorkload() async {
  final response = await dio.get(ApiEndpoints.agentWorkload);
  return response.data;
}

Future<List<dynamic>> getKbArticles() async {
  final response = await dio.get(ApiEndpoints.kbArticles);
  return response.data;
}

     Future<List<dynamic>> fetchStaffs() async {
  final response =
      await dio.get(
          ApiEndpoints.fetchStaffs);

  return response.data;
}

  Future<void> createTicket({
    required Map<String, dynamic> payload,
    required List<File> files,
  }) async {
    FormData formData = FormData();

    formData.files.add(
      MapEntry(
        "data",
        MultipartFile.fromString(
          jsonEncode(payload),
          contentType: MediaType(
            "application",
            "json",
          ),
        ),
      ),
    );

    for (final file in files) {
      formData.files.add(
        MapEntry(
          "files",
          await MultipartFile.fromFile(
            file.path,
            filename:
                file.path.split('/').last,
          ),
        ),
      );
    }

    await dio.post(
      ApiEndpoints.createTicket,
      data: formData,
    );
  }

  

  Future<void> assignAgent(
  int ticketId,
  int userId,
) async {

  await dio.put(
    '/tickets/$ticketId/assign/$userId',
  );
}


Future<void> updateStatus(
  int ticketId,
  String oldStatus,
  String newStatus,
  String reason,
) async {

  await dio.patch(
    '/tickets/status/$ticketId/update',
    data: {
      "ticketId": ticketId,
      "newStatus": newStatus,
      "oldStatus": oldStatus,
      "reason": reason,
    },
  );
}

  Future<void> createCategory(
    Map<String, dynamic> payload,
  ) async {
    await dio.post(
      ApiEndpoints.createCategory,
      data: payload,
    );
  }

  Future<List<dynamic>> getComments(
    int ticketId,
  ) async {
    final response = await dio.get(
      '${ApiEndpoints.commentBase}/$ticketId/get-comments',
    );

    return response.data;
  }

  Future<void> addComment({
    required int ticketId,
    required String text,
    required List<File> files,
  }) async {
    FormData formData = FormData();

    final payload = {
      "ticketId": ticketId,
      "body": text,
      "internal": true,
    };

    formData.files.add(
      MapEntry(
        "data",
        MultipartFile.fromString(
          jsonEncode(payload),
          contentType: MediaType(
            "application",
            "json",
          ),
        ),
      ),
    );

    for (final file in files) {
      formData.files.add(
        MapEntry(
          "files",
          await MultipartFile.fromFile(
            file.path,
            filename:
                file.path.split('/').last,
          ),
        ),
      );
    }

    await dio.post(
      '${ApiEndpoints.commentBase}/$ticketId/add-comment',
      data: formData,
    );
  }

  Future<void> deleteComment(
    int commentId,
  ) async {
    await dio.delete(
      '${ApiEndpoints.commentBase}/$commentId/delete',
    );
  }

  Future<void> deleteAttachment(
    int attachmentId,
  ) async {
    await dio.delete(
      '${ApiEndpoints.commentBase}/attachment/$attachmentId/delete',
    );
  }
}