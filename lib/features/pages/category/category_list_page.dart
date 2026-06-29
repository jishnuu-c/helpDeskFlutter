import 'package:flutter/material.dart';
import 'add_category_dialog.dart';

import '../../controllers/category_controller.dart';
import '../../../models/category_model.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final CategoryController controller = CategoryController();

  List<Category> categories = [];
  List<Category> parentCategories = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    categories = await controller.getCategories();

    parentCategories = categories.where((c) {
      return c.parentId == null;
    }).toList();

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),

        label: const Text("Add Category"),

        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCategoryPage()),
          );

          if (result == true) {
            loadData();
          }
        },
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(20),

        itemCount: parentCategories.length,

        itemBuilder: (_, index) {
          final category = parentCategories[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 15),

            elevation: 4,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),

            child: ListTile(
              leading: const Icon(Icons.folder, color: Colors.blue),

              title: Text(
                category.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              subtitle: Text(category.description),
            ),
          );
        },
      ),
    );
  }
}
