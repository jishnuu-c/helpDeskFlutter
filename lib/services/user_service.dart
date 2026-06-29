import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserService {
  final UserRepository repository = UserRepository();

  Future<List<User>> getUsers() async {
    final response = await repository.getUsers();
    return response.map<User>((e) => User.fromJson(e)).toList();
  }

  Future<List<dynamic>> fetchStaffs() {
    return repository.fetchStaffs();
  }
}
