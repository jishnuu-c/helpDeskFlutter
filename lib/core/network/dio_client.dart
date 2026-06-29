
import 'package:dio/dio.dart';

import 'api_endpoints.dart';
import 'auth_interceptor.dart';

class DioClient {

  static final Dio dio = Dio(

    BaseOptions(

      baseUrl: ApiEndpoints.baseUrl,

      connectTimeout:
          const Duration(seconds: 30),

      receiveTimeout:
          const Duration(seconds: 30),

      headers: {
        "Content-Type":
            "application/json",
      },
    ),
  )
    ..interceptors.add(
      AuthInterceptor(),
    );
}