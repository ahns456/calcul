import 'package:calcul/data/history_repository.dart';
import 'package:calcul/domain/models/calculation_record.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late HistoryRepository repo;

  setUpAll(() async {
    Hive.init('./test/hive');
    repo = HistoryRepository();
    await repo.init();
  });

  test('add and delete record', () async {
    final record = CalculationRecord(
      expression: '1+1',
      result: '2',
      timestamp: DateTime.now(),
    );
    await repo.add(record);
    final all = repo.getAll();
    expect(all.first.value.expression, '1+1');
    await repo.delete(all.first.key);
    expect(repo.getAll().isEmpty, isTrue);
  });
}
