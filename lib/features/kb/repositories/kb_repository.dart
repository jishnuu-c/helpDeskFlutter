import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';

class KbRepository {
  final Dio dio = DioClient.dio;

  Future<List<dynamic>> getKbArticles() async {
    final response = await dio.get(ApiEndpoints.kbArticles);
    return response.data;
  }
}
