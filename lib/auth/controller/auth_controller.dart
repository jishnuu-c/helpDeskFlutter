import 'package:flutter/material.dart';

import '../../core/storage/token_storage.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../repository/auth_repository.dart';

class AuthController extends ChangeNotifier {

  final AuthRepository _repository =
      AuthRepository();

  bool isLoading = false;

 Future<bool> login({
  required String email,
  required String password,
}) async {

  try {

    isLoading = true;
    notifyListeners();

    final response =
        await _repository.login(
      LoginRequest(
        email: email,
        password: password,
      ),
    );

    print(response.data);

    final token =
        response.data["token"];

    if (token == null) {
      print("Token null");
      return false;
    }

    await TokenStorage.saveToken(
      token,
    );

    return true;

  } catch (e) {

    print(e);

    return false;

  } finally {

    isLoading = false;
    notifyListeners();
  }
}

  Future<bool> register({

    required String fullName,
    required String email,
    required String phone,
    required String password,

  }) async {

    try {

      isLoading = true;
      notifyListeners();

      await _repository.register(

        RegisterRequest(
          fullName: fullName,
          email: email,
          phone: phone,
          password: password,
          role: "END_USER",
        ),
      );

      return true;

    } catch (e) {

      return false;

    } finally {

      isLoading = false;
      notifyListeners();
    }
  }
}