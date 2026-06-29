import '../repositories/kb_repository.dart';

class KbService {
  final KbRepository repository = KbRepository();

  Future<List<dynamic>> getKbArticles() {
    return repository.getKbArticles();
  }
}
