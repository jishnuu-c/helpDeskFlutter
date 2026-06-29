import 'package:flutter/material.dart';

import '../../models/sla_policy_model.dart';
import '../../repositories/sla_repository.dart';

class SlaController extends ChangeNotifier {
  final SlaRepository repository = SlaRepository();

  bool loading = false;

  List<SlaPolicy> slas = [];

  Future<void> loadSlas() async {
    loading = true;
    notifyListeners();

    try {
      slas = await repository.getSlas();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> createSla(SlaPolicy sla) async {
    final created = await repository.createSla(sla);

    slas.insert(0, created);

    notifyListeners();
  }
}
