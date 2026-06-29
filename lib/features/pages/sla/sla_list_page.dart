import 'package:flutter/material.dart';

import '../../controllers/sla_controller.dart';
import 'add_sla_page.dart';

class SlaListPage extends StatefulWidget {
  const SlaListPage({super.key});

  @override
  State<SlaListPage> createState() => _SlaListPageState();
}

class _SlaListPageState extends State<SlaListPage> {
  final controller = SlaController();

  @override
  void initState() {
    super.initState();
    controller.loadSlas();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        if (controller.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddSlaPage(controller: controller),
                ),
              );

              setState(() {});
            },
            child: const Icon(Icons.add),
          ),

          body: ListView.builder(
            itemCount: controller.slas.length,
            itemBuilder: (context, index) {
              final sla = controller.slas[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(sla.name),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Response: ${sla.responseMinutes} min"),
                      Text("Resolution: ${sla.resolutionMinutes} min"),
                    ],
                  ),

                  trailing: Chip(label: Text(sla.priorityLevel)),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
