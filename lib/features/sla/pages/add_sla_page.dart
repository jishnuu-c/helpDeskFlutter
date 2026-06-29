import 'package:flutter/material.dart';

import '../controllers/sla_controller.dart';
import '../models/sla_policy_model.dart';

class AddSlaPage extends StatefulWidget {
  final SlaController controller;

  const AddSlaPage({
    super.key,
    required this.controller,
  });

  @override
  State<AddSlaPage> createState() =>
      _AddSlaPageState();
}

class _AddSlaPageState
    extends State<AddSlaPage> {
  final formKey = GlobalKey<FormState>();

  final nameController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  final responseController =
      TextEditingController();

  final resolutionController =
      TextEditingController();

  final escalationController =
      TextEditingController();

  String priority = "LOW";

  bool active = true;

  bool escalationEnabled = true;

  bool loading = false;

  Future<void> save() async {
    if (!formKey.currentState!
        .validate()) return;

    setState(() {
      loading = true;
    });

    final sla = SlaPolicy(
      name: nameController.text,
      priorityLevel: priority,
      description:
          descriptionController.text,
      escalateEnabled:
          escalationEnabled,
      escalationMinutes:
          int.parse(
              escalationController.text),
      responseMinutes:
          int.parse(
              responseController.text),
      resolutionMinutes:
          int.parse(
              resolutionController.text),
      isActive: active,
    );

    await widget.controller
        .createSla(sla);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Add SLA")),

      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller:
                    nameController,
                decoration:
                    const InputDecoration(
                  labelText: "Name",
                ),
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField(
                value: priority,
                items: const [
                  DropdownMenuItem(
                    value: "LOW",
                    child: Text("LOW"),
                  ),
                  DropdownMenuItem(
                    value: "MEDIUM",
                    child:
                        Text("MEDIUM"),
                  ),
                  DropdownMenuItem(
                    value: "HIGH",
                    child: Text("HIGH"),
                  ),
                  DropdownMenuItem(
                    value: "CRITICAL",
                    child: Text(
                        "CRITICAL"),
                  ),
                ],
                onChanged: (v) {
                  priority = v!;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller:
                    responseController,
                keyboardType:
                    TextInputType.number,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Response Minutes",
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller:
                    resolutionController,
                keyboardType:
                    TextInputType.number,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Resolution Minutes",
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller:
                    escalationController,
                keyboardType:
                    TextInputType.number,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Escalation Minutes",
                ),
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed:
                    loading ? null : save,
                child: Text(
                  loading
                      ? "Saving..."
                      : "Create SLA",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}