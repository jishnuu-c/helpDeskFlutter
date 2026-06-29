import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryController {
  final CategoryService service = CategoryService();

  Future<List<Category>> getCategories() async {
    final data = await service.getCategories();
    return data.map<Category>((e) => Category.fromJson(e)).toList();
  }

  Future<void> createCategory(Map<String, dynamic> payload) {
    return service.createCategory(payload);
  }
}
