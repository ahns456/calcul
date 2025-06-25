import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers.dart';
import '../../application/history_provider.dart';
import '../../domain/models/calculation_record.dart';
import '../../domain/use_cases/calculate.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/calc_button.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _append(WidgetRef ref, String value) {
    var expression = ref.read(expressionProvider);
    if (value == '.') {
      final match =
          RegExp(r'(\d+\.\d*|\d*\.\d+|\d+)\$').firstMatch(expression);
      if (match != null && match.group(0)!.contains('.')) {
        return;
      }
    }
    if (value == '±') {
      if (expression.isEmpty || RegExp(r'[+\-*/(]$').hasMatch(expression)) {
        expression += '-';
      } else {
        expression = '-($expression)';
      }
      ref.read(expressionProvider.notifier).state = expression;
      return;
    }
    ref.read(expressionProvider.notifier).state = expression + value;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final expression = ref.watch(expressionProvider);
    final result = ref.watch(resultProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () async {
              await ref.read(historyProvider.notifier).load();
              Navigator.pushNamed(context, '/history');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(expression, style: Theme.of(context).textTheme.titleLarge),
                Text(result, style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              children: [
              for (final label in [
                '7',
                '8',
                '9',
                '/',
                '4',
                '5',
                '6',
                '*',
                '1',
                '2',
                '3',
                '-',
                '0',
                '.',
                '±',
                '+',
                '(',
                ')',
                '=',
                'C'
              ])
                CalcButton(
                  label: label,
                  onPressed: () {
                    if (label == 'C') {
                      ref.read(expressionProvider.notifier).state = '';
                      ref.read(resultProvider.notifier).state = '0';
                    } else if (label == '=') {
                      try {
                        final exp = ref.read(expressionProvider);
                        final calculator = ref.read(calculateUseCaseProvider);
                        final value = calculator.call(exp);
                        ref.read(resultProvider.notifier).state = value.toString();
                        final record = CalculationRecord(
                          expression: exp,
                          result: value.toString(),
                          timestamp: DateTime.now(),
                        );
                        ref.read(historyProvider.notifier).add(record);
                      } catch (_) {
                        ref.read(resultProvider.notifier).state = 'Err';
                      }
                    } else {
                      _append(ref, label);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

