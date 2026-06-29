import 'package:dio/dio.dart';

import '../core/network/api_endpoints.dart';
import '../core/network/dio_client.dart';

class SlaService {
  final Dio dio = DioClient.dio;

  Future<Response> getSlas() async {
    return await dio.get(
      ApiEndpoints.getSlas,
    );
  }

  Future<Response> createSla(
    Map<String, dynamic> data,
  ) async {
    return await dio.post(
      ApiEndpoints.createSla,
      data: data,
    );
  }
}