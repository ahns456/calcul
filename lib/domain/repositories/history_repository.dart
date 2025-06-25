import '../models/history_entry.dart';

abstract class HistoryRepository {
  Future<void> add(HistoryEntry entry);
  List<HistoryEntry> getAll();
  Future<void> delete(int index);
}
