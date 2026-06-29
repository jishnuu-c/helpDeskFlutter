import 'package:flutter/material.dart';

import '../../controller/department_controller.dart';
import '../../models/department_model.dart';
import 'add_department_page.dart';

class DepartmentPage extends StatefulWidget {
  const DepartmentPage({super.key});

  @override
  State<DepartmentPage> createState() =>
      _DepartmentPageState();
}

class _DepartmentPageState
    extends State<DepartmentPage> {

  final DepartmentController controller =
      DepartmentController();

  List<Department> departments = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDepartments();
  }

  Future<void> loadDepartments() async {
    departments =
        await controller.getDepartments();

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    return Scaffold(
      floatingActionButton:
          FloatingActionButton(
        onPressed: () async {

          final result =
              await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const AddDepartmentPage(),
            ),
          );

          if (result == true) {
            loadDepartments();
          }
        },

        child: const Icon(Icons.add),
      ),

      body: departments.isEmpty
          ? const Center(
              child:
                  Text("No Departments"),
            )
          : ListView.builder(
              padding:
                  const EdgeInsets.all(
                15,
              ),

              itemCount:
                  departments.length,

              itemBuilder:
                  (context, index) {

                final department =
                    departments[index];

                return Card(
                  margin:
                      const EdgeInsets.only(
                    bottom: 12,
                  ),

                  child: ListTile(
                    leading:
                        CircleAvatar(
                      backgroundColor:
                          Colors.blue,
                      child: Text(
                        department
                            .name[0]
                            .toUpperCase(),
                      ),
                    ),

                    title: Text(
                      department.name,
                    ),

                    subtitle: Text(
                      department
                              .description ??
                          "",
                    ),

                    trailing: Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),

                      decoration:
                          BoxDecoration(
                        color: department
                                .isActive
                            ? Colors.green
                                .shade100
                            : Colors.red
                                .shade100,

                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),

                      child: Text(
                        department
                                .isActive
                            ? "Active"
                            : "Inactive",
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}