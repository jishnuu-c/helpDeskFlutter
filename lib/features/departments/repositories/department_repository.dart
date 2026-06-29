import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart' show ApiEndpoints;
import '../../../../core/network/dio_client.dart';

class DepartmentRepository {
  final Dio dio = DioClient.dio;

  Future<List<dynamic>> getDepartments() async {
    final response = await dio.get(
      ApiEndpoints.departments,
    );

    return response.data;
  }

  Future<dynamic> createDepartment(
    Map<String, dynamic> data,
  ) async {
    final response = await dio.post(
      ApiEndpoints.createDepartment,
      data: data,
    );

    return response.data;
  }
}