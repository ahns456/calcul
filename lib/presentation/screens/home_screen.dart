import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/calc_button.dart';
import 'settings_screen.dart';
import 'history_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _append(WidgetRef ref, String value) {
    final expression = ref.read(expressionProvider);
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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
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
                Text(expression, style: Theme.of(context).textTheme.headline5),
                Text(result, style: Theme.of(context).textTheme.headline4),
              ],
            ),
          ),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            children: [
              for (final label in ['7','8','9','/','4','5','6','*','1','2','3','-','0','=','C','+'])
                CalcButton(
                  label: label,
                  onPressed: () async {
                    if (label == 'C') {
                      ref.read(expressionProvider.notifier).state = '';
                      ref.read(resultProvider.notifier).state = '0';
                    } else if (label == '=') {
                      try {
                        final exp = ref.read(expressionProvider);
                        final value = _compute(exp);
                        ref.read(resultProvider.notifier).state = value.toString();
                        await ref
                            .read(historyListProvider.notifier)
                            .add(exp, value.toString());
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
        ],
      ),
    );
  }
}

double _compute(String expression) {
  // Very naive evaluation (for demo only).
  try {
    final sanitized = expression.replaceAll('*', ' * ').replaceAll('/', ' / ');
    final tokens = sanitized.split(' ');
    double result = double.parse(tokens.first);
    for (var i = 1; i < tokens.length; i += 2) {
      final op = tokens[i];
      final value = double.parse(tokens[i + 1]);
      switch (op) {
        case '+':
          result += value;
          break;
        case '-':
          result -= value;
          break;
        case '*':
          result *= value;
          break;
        case '/':
          result /= value;
          break;
      }
    }
    return result;
  } catch (e) {
    throw Exception('Invalid expression');
  }
}
