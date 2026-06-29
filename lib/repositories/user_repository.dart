import 'package:dio/dio.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class UserRepository {
  final Dio dio = DioClient.dio;

  Future<List<dynamic>> getUsers() async {
    final response = await dio.get(ApiEndpoints.users);
    return response.data;
  }

  Future<List<dynamic>> fetchStaffs() async {
    final response = await dio.get(ApiEndpoints.fetchStaffs);
    return response.data;
  }
}
