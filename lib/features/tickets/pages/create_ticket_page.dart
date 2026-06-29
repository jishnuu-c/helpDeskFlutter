import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../controllers/ticket_controller.dart';
import '../../categories/models/category_model.dart';
import '../../categories/controllers/category_controller.dart';
import '../../departments/models/department_model.dart';
import '../../departments/controllers/department_controller.dart';
import '../../sla/models/sla_policy_model.dart';
import '../../sla/controllers/sla_controller.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({super.key});

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  final TicketController controller = TicketController();
  final DepartmentController departmentController = DepartmentController();
  final SlaController slaController = SlaController();
  final CategoryController categoryController = CategoryController();

  final subjectController = TextEditingController();

  final descriptionController = TextEditingController();

  List<Department> departments = [];
  List<SlaPolicy> slas = [];
  List<Category> categories = [];

  List<Category> parentCategories = [];
  List<Category> subCategories = [];

  int? departmentId;
  int? slaPolicyId;
  int? parentCategoryId;
  int? categoryId;

  String? priority;
  String? channel;

  bool loading = true;
  bool submitting = false;

  List<File> files = [];

  @override
  void initState() {
    super.initState();
    loadMasterData();
  }

  Future<void> loadMasterData() async {
    try {
      departments = await departmentController.getDepartments();

      print("DEPARTMENT LOADED");
    } catch (e) {
      print("DEPARTMENT ERROR: $e");
    }

    try {
      await slaController.loadSlas();
      slas = slaController.slas;

       print("SLA LOADED");

  for (var s in slas) {
    print("${s.slaPolicyId} - ${s.name}");
  }

    } catch (e) {
      print("SLA ERROR: $e");
    }

    try {
      categories = await categoryController.getCategories();

      print("CATEGORY LOADED");

      for (var c in categories) {
        print("${c.categoryId} - ${c.name} - ${c.parentId}");
      }

      parentCategories = categories.where((c) {
        return c.parentId == null;
      }).toList();
    } catch (e) {
      print("CATEGORY ERROR: $e");
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      files = result.paths.map((e) => File(e!)).toList();

      setState(() {});
    }
  }

  Future<void> submit() async {
    if (subjectController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        priority == null ||
        channel == null ||
        departmentId == null ||
        slaPolicyId == null ||
        categoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));

      return;
    }

    setState(() {
      submitting = true;
    });

    try {
      print({
        "subject": subjectController.text.trim(),
        "description": descriptionController.text.trim(),
        "priority": priority,
        "channel": channel,
        "departmentId": departmentId,
        "slaPolicyId": slaPolicyId,
        "categoryId": categoryId,
      });

      await controller.createTicket(
        payload: {
          "subject": subjectController.text.trim(),
          "description": descriptionController.text.trim(),
          "priority": priority,
          "channel": channel,
          "departmentId": departmentId,
          "slaPolicyId": slaPolicyId,
          "categoryId": categoryId,
        },
        files: files,
      );

      ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: const Row(
      children: [
        Icon(Icons.check_circle, color: Colors.white),
        SizedBox(width: 10),
        Text("Ticket created successfully!"),
      ],
    ),
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    duration: const Duration(seconds: 2),
  ),
);

await Future.delayed(const Duration(seconds: 2)); 

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() {
      submitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    print("parentCategoryId = $parentCategoryId");
  print(
    parentCategories.map((e) => e.categoryId).toList(),
  );

  print("categoryId = $categoryId");
  print(
    subCategories.map((e) => e.categoryId).toList(),
  );

    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Create Ticket")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Card(
          elevation: 4,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  "Ticket Details",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 25),

                TextField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    labelText: "Subject",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: priority,
                        decoration: const InputDecoration(
                          labelText: "Priority",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: "LOW", child: Text("LOW")),
                          DropdownMenuItem(
                            value: "MEDIUM",
                            child: Text("MEDIUM"),
                          ),
                          DropdownMenuItem(value: "HIGH", child: Text("HIGH")),
                          DropdownMenuItem(
                            value: "CRITICAL",
                            child: Text("CRITICAL"),
                          ),
                        ],
                        onChanged: (String? v) {
                          setState(() {
                            priority = v;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: DropdownButtonFormField(
                        value: channel,
                        decoration: const InputDecoration(
                          labelText: "Channel",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: "WEB", child: Text("WEB")),
                          DropdownMenuItem(
                            value: "EMAIL",
                            child: Text("EMAIL"),
                          ),
                          DropdownMenuItem(
                            value: "PHONE",
                            child: Text("PHONE"),
                          ),
                          DropdownMenuItem(
                            value: "MOBILE",
                            child: Text("MOBILE"),
                          ),
                        ],
                        onChanged: (v) {
                          setState(() {
                            channel = v;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<int>(
                  value: departments.any((d) => d.departmentId == departmentId)
                      ? departmentId
                      : null,
                  decoration: const InputDecoration(
                    labelText: "Department",
                    border: OutlineInputBorder(),
                  ),
                  items: departments.map<DropdownMenuItem<int>>((d) {
                    return DropdownMenuItem<int>(
                      value: d.departmentId,
                      child: Text(d.name),
                    );
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      departmentId = v;
                    });
                  },
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<int>(
                  value: slas.any((s) => s.slaPolicyId == slaPolicyId)
                      ? slaPolicyId
                      : null,
                  decoration: const InputDecoration(
                    labelText: "SLA Policy",
                    border: OutlineInputBorder(),
                  ),
                  items: slas.map<DropdownMenuItem<int>>((s) {
                    return DropdownMenuItem<int>(
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

                DropdownButtonFormField<int>(
                  value:
                      parentCategories.any(
                        (c) => c.categoryId == parentCategoryId,
                      )
                      ? parentCategoryId
                      : null,
                  decoration: const InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(),
                  ),
                  items: parentCategories.map<DropdownMenuItem<int>>((c) {
                    return DropdownMenuItem<int>(
                      value: c.categoryId,
                      child: Text(c.name),
                    );
                  }).toList(),
                  onChanged: (int? v) {
                    print("CATEGORY = $v");

                    // FIX 4: Randum String aakki compare cheyyuka (Dart type mismatch ozhivakkan)
                    final filtered = categories.where((c) {
                      if (c.parentId == null || v == null) return false;
                      return c.parentId.toString() == v.toString();
                    }).toList();

                    print("SUBCATEGORY COUNT = ${filtered.length}");

                    setState(() {
                      parentCategoryId = v;
                      subCategories = filtered;
                      categoryId = null;
                    });
                  },
                ),
                const SizedBox(height: 20),

                if (subCategories.isNotEmpty)
                  DropdownButtonFormField<int>(
                    value: subCategories.any((c) => c.categoryId == categoryId)
                        ? categoryId
                        : null,
                    decoration: const InputDecoration(
                      labelText: "Sub Category",
                      border: OutlineInputBorder(),
                    ),
                    items: subCategories.map<DropdownMenuItem<int>>((c) {
                      return DropdownMenuItem<int>(
                        value: c.categoryId,
                        child: Text(c.name),
                      );
                    }).toList(),
                    onChanged: (int? v) {
                      setState(() {
                        categoryId = v;
                      });
                    },
                  ),
                const SizedBox(height: 25),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.cloud_upload,
                        size: 50,
                        color: Colors.blue,
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: pickFiles,
                        child: const Text("Choose Files"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                ...files.map(
                  (f) => ListTile(
                    leading: const Icon(Icons.attach_file),
                    title: Text(f.path.split("/").last),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: submitting ? null : submit,
                    child: submitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Create Ticket"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
