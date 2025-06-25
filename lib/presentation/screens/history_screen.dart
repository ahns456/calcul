import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers.dart';
import '../../l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(historyListProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.history)),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return Dismissible(
            key: ValueKey('${entry.expression}-${entry.timestamp}'),
            onDismissed: (_) {
              ref.read(historyListProvider.notifier).remove(index);
            },
            child: ListTile(
              title: Text(entry.expression),
              subtitle: Text(entry.result),
              trailing: Text(DateFormat.Hm().format(entry.timestamp)),
            ),
          );
        },
      ),
    );
  }
}
