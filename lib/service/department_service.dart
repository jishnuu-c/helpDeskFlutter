import '../auth/models/department_model.dart';
import '../auth/repository/department_repository.dart';

class DepartmentService {
  final DepartmentRepository
      repository =
      DepartmentRepository();

  Future<List<Department>>
      getDepartments() async {

    final response =
        await repository
            .getDepartments();

    return (response as List)
        .map(
          (e) => Department.fromJson(e),
        )
        .toList();
  }

  Future<void>
      createDepartment(
    Map<String, dynamic> data,
  ) async {
    await repository
        .createDepartment(data);
  }
}