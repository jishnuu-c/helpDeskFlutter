import '../repositories/category_repository.dart';

class CategoryService {
  final CategoryRepository repository = CategoryRepository();

  Future<List<dynamic>> getCategories() {
    return repository.getCategories();
  }

  Future<void> createCategory(Map<String, dynamic> payload) {
    return repository.createCategory(payload);
  }
}
