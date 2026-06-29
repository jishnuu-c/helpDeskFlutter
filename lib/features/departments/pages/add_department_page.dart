import 'package:flutter/material.dart';

import '../controllers/department_controller.dart';

class AddDepartmentPage
    extends StatefulWidget {

  const AddDepartmentPage({
    super.key,
  });

  @override
  State<AddDepartmentPage>
      createState() =>
          _AddDepartmentPageState();
}

class _AddDepartmentPageState
    extends State<AddDepartmentPage> {

  final DepartmentController controller =
      DepartmentController();

  final nameController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  bool saving = false;

  Future<void> saveDepartment() async {

    if (nameController.text.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Enter name"),
        ),
      );

      return;
    }

    setState(() {
      saving = true;
    });

    await controller.createDepartment({
      "name":
          nameController.text.trim(),

      "description":
          descriptionController.text
              .trim(),

      "isActive": true,
    });

    if (mounted) {
      Navigator.pop(
        context,
        true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Department",
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller:
                  nameController,

              decoration:
                  const InputDecoration(
                labelText: "Name",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            TextField(
              controller:
                  descriptionController,

              maxLines: 4,

              decoration:
                  const InputDecoration(
                labelText:
                    "Description",

                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(
              width:
                  double.infinity,

              height: 55,

              child:
                  ElevatedButton(
                onPressed:
                    saving
                        ? null
                        : saveDepartment,

                child:
                    saving
                        ? const CircularProgressIndicator(
                            color:
                                Colors.white,
                          )
                        : const Text(
                            "Save Department",
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}