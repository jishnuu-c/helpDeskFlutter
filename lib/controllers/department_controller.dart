import '../../services/department_service.dart';
import '../../models/department_model.dart';

class DepartmentController {
  final DepartmentService service = DepartmentService();

  Future<List<Department>> getDepartments() async {
    return await service.getDepartments();
  }

  Future<void> createDepartment(Map<String, dynamic> data) async {
    await service.createDepartment(data);
  }
}
