import 'package:flutter/material.dart';

import '../../controllers/category_controller.dart';
import '../../../models/category_model.dart';
import '../../../models/sla_policy_model.dart';
import '../../controllers/sla_controller.dart';
import '../../../models/user_model.dart';
import '../../../services/user_service.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final CategoryController categoryController = CategoryController();
  final SlaController slaController = SlaController();
  final UserService userService = UserService();

  final nameController = TextEditingController();

  final descriptionController = TextEditingController();

  List<Category> categories = [];
  List<Category> parentCategories = [];
  List<SlaPolicy> slas = [];
  List<User> users = [];

  String categoryType = "MAIN";

  int? parentId;
  int? userId;
  int? slaPolicyId;

  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    categories = await categoryController.getCategories();

    await slaController.loadSlas();
    slas = slaController.slas;

    users = await userService.getUsers();

    parentCategories = categories.where((c) {
      return c.parentId == null;
    }).toList();

    setState(() {
      loading = false;
    });
  }

  Future<void> saveCategory() async {
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        userId == null ||
        slaPolicyId == null ||
        (categoryType == "SUB" && parentId == null)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));

      return;
    }

    setState(() {
      saving = true;
    });

    await categoryController.createCategory({
      "name": nameController.text.trim(),

      "description": descriptionController.text.trim(),

      "userId": userId,

      "slaPolicyId": slaPolicyId,

      "parentId": categoryType == "SUB" ? parentId : null,
    });

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Add Category")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: categoryType,

              decoration: const InputDecoration(
                labelText: "Category Type",
                border: OutlineInputBorder(),
              ),

              items: const [
                DropdownMenuItem(value: "MAIN", child: Text("Parent Category")),

                DropdownMenuItem(value: "SUB", child: Text("Sub Category")),
              ],

              onChanged: (v) {
                setState(() {
                  categoryType = v!;
                  parentId = null;
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            if (categoryType == "SUB") ...[
              DropdownButtonFormField<int>(
                value: parentId,

                decoration: const InputDecoration(
                  labelText: "Parent Category",
                  border: OutlineInputBorder(),
                ),

                items: parentCategories.map((c) {
                  return DropdownMenuItem(
                    value: c.categoryId,
                    child: Text(c.name),
                  );
                }).toList(),

                onChanged: (v) {
                  setState(() {
                    parentId = v;
                  });
                },
              ),

              const SizedBox(height: 20),
            ],

            DropdownButtonFormField<int>(
              value: userId,

              decoration: const InputDecoration(
                labelText: "Assign User",
                border: OutlineInputBorder(),
              ),

              items: users.map((u) {
                return DropdownMenuItem(value: u.id, child: Text(u.fullName));
              }).toList(),

              onChanged: (v) {
                setState(() {
                  userId = v;
                });
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<int>(
              value: slaPolicyId,

              decoration: const InputDecoration(
                labelText: "SLA Policy",
                border: OutlineInputBorder(),
              ),

              items: slas.map((s) {
                return DropdownMenuItem(
                  value: s.slaPolicyId,

                  child: Text(s.name),
                );
              }).toList(),

              onChanged: (v) {
                setState(() {
                  slaPolicyId = v;
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: descriptionController,

              maxLines: 4,

              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              height: 55,

              child: ElevatedButton(
                onPressed: saving ? null : saveCategory,

                child: saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save Category"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
