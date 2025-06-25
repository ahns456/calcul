import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:calcul/application/history_provider.dart';
import 'package:calcul/data/history_repository.dart';
import 'package:calcul/domain/models/calculation_record.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;
  late HistoryRepository repo;

  setUpAll(() async {
    Hive.init('./test/hive_notifier');
    repo = HistoryRepository();
    await repo.init();
    container = ProviderContainer(overrides: [
      historyRepositoryProvider.overrideWithValue(repo),
    ]);
  });

  tearDownAll(() async {
    await Hive.deleteBoxFromDisk(HistoryRepository.boxName);
    container.dispose();
  });

  test('add and delete via notifier', () async {
    final notifier = container.read(historyProvider.notifier);
    final record = CalculationRecord(
      expression: '1+1',
      result: '2',
      timestamp: DateTime.now(),
    );

    await notifier.add(record);
    expect(container.read(historyProvider).length, 1);

    final key = container.read(historyProvider).first.key;
    await notifier.delete(key);
    expect(container.read(historyProvider), isEmpty);
  });
}
