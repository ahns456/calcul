import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/history_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: history.isEmpty
          ? const Center(child: Text('No records'))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final entry = history[index];
                final record = entry.value;
                return Dismissible(
                  key: ValueKey(entry.key),
                  onDismissed: (_) {
                    ref
                        .read(historyProvider.notifier)
                        .delete(entry.key);
                  },
                  background: Container(color: Colors.red),
                  child: ListTile(
                    title: Text('${record.expression} = ${record.result}'),
                    subtitle: Text(
                        '${record.timestamp.toLocal().toIso8601String().substring(0, 19)}'),
                  ),
                );
              },
            ),
    );
  }
}
