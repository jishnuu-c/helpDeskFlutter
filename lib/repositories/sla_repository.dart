import '../services/sla_service.dart';
import '../models/sla_policy_model.dart';

class SlaRepository {
  final SlaService service = SlaService();

  Future<List<SlaPolicy>> getSlas() async {
    final response = await service.getSlas();

    return (response.data as List).map((e) => SlaPolicy.fromJson(e)).toList();
  }

  Future<SlaPolicy> createSla(SlaPolicy sla) async {
    final response = await service.createSla(sla.toJson());

    return SlaPolicy.fromJson(response.data);
  }
}
