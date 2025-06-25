import 'package:hive/hive.dart';
import '../domain/models/calculation_record.dart';

class HistoryRepository {
  static const boxName = 'history';
  late Box<CalculationRecord> _box;

  Future<void> init() async {
    Hive.registerAdapter(CalculationRecordAdapter());
    _box = await Hive.openBox<CalculationRecord>(boxName);
  }

  List<MapEntry<int, CalculationRecord>> getAll() {
    return _box.keys
        .cast<int>()
        .map((k) => MapEntry(k, _box.get(k)!))
        .toList()
        .reversed
        .toList();
  }

  Future<void> add(CalculationRecord record) async {
    await _box.add(record);
  }

  Future<void> delete(int key) async {
    await _box.delete(key);
  }
}
