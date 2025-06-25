import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/history_entry.dart';
import '../domain/repositories/history_repository.dart';

class HistoryNotifier extends StateNotifier<List<HistoryEntry>> {
  HistoryNotifier(this._repository) : super(_repository.getAll());

  final HistoryRepository _repository;

  Future<void> add(String expression, String result) async {
    final entry = HistoryEntry(
      expression: expression,
      result: result,
      timestamp: DateTime.now(),
    );
    await _repository.add(entry);
    state = _repository.getAll();
  }

  Future<void> remove(int index) async {
    await _repository.delete(index);
    state = _repository.getAll();
  }
}
