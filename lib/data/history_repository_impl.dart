import 'package:hive/hive.dart';
import '../domain/models/history_entry.dart';
import '../domain/repositories/history_repository.dart';

class HiveHistoryRepository implements HistoryRepository {
  HiveHistoryRepository(this._box);

  final Box<HistoryEntry> _box;

  @override
  Future<void> add(HistoryEntry entry) async {
    await _box.add(entry);
  }

  @override
  List<HistoryEntry> getAll() {
    return _box.values.toList();
  }

  @override
  Future<void> delete(int index) async {
    await _box.deleteAt(index);
  }
}
