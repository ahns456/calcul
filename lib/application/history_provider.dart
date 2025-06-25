import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/history_repository.dart';
import '../domain/models/calculation_record.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) => HistoryRepository());

class HistoryNotifier extends StateNotifier<List<MapEntry<int, CalculationRecord>>> {
  HistoryNotifier(this._repo) : super([]);

  final HistoryRepository _repo;

  Future<void> load() async {
    state = _repo.getAll();
  }

  Future<void> add(CalculationRecord record) async {
    await _repo.add(record);
    await load();
  }

  Future<void> delete(int key) async {
    await _repo.delete(key);
    await load();
  }
}

final historyProvider = StateNotifierProvider<HistoryNotifier, List<MapEntry<int, CalculationRecord>>>((ref) {
  final repo = ref.watch(historyRepositoryProvider);
  return HistoryNotifier(repo);
});
