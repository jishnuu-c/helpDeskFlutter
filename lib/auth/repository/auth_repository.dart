import '../../core/network/dio_client.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  Future<Response> login(LoginRequest request) async {
    final response = await DioClient.dio.post(
      "/auth/login",
      data: request.toJson(),
    );

    print("STATUS: ${response.statusCode}");
    print("DATA: ${response.data}");

    return response;
  }

  Future<Response> register(RegisterRequest request) async {
    return await DioClient.dio.post("/auth/register", data: request.toJson());
  }
}
