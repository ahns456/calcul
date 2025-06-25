import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:calcul/data/history_repository_impl.dart';
import 'package:calcul/domain/models/history_entry.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
    Hive.registerAdapter(HistoryEntryAdapter());
    await Hive.openBox<HistoryEntry>('history');
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  test('add and fetch history', () async {
    final box = Hive.box<HistoryEntry>('history');
    final repo = HiveHistoryRepository(box);

    final entry = HistoryEntry(expression: '1+1', result: '2', timestamp: DateTime.now());
    await repo.add(entry);

    final all = repo.getAll();
    expect(all.length, 1);
    expect(all.first.expression, '1+1');
  });
}
