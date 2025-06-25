import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers.dart';
import '../../application/history_provider.dart';
import '../../domain/models/calculation_record.dart';
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
          // 키패드 영역 크기 제한으로 스크롤 방지
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5, // 화면 높이의 50%로 제한
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.2, // 버튼 비율 조정 (가로가 세로보다 약간 길게)
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
                      } else if (label == '=') {
                        final exp = ref.read(expressionProvider);
                        final res = ref.read(resultProvider);
                        if (exp.isNotEmpty && res != 'Err') {
                          final record = CalculationRecord(
                            expression: exp,
                            result: res,
                            timestamp: DateTime.now(),
                          );
                          ref.read(historyProvider.notifier).add(record);
                        }
                      } else {
                        _append(ref, label);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

