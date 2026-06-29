import 'package:dio/dio.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class CategoryRepository {
  final Dio dio = DioClient.dio;

  Future<List<dynamic>> getCategories() async {
    final response = await dio.get(ApiEndpoints.categories);
    return response.data;
  }

  Future<void> createCategory(Map<String, dynamic> payload) async {
    await dio.post(ApiEndpoints.createCategory, data: payload);
  }
}
