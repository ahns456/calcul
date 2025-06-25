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
          // 키패드 영역 - 스크롤 없이 고정 크기로 설정
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.count(
              shrinkWrap: true, // 컨텐츠 크기에 맞게 축소
              physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
              crossAxisCount: 4,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 1.1, // 버튼 비율 조정 (약간 세로가 짧게)
                children: [
                  // 첫 번째 줄: 기능 버튼들
                  CalcButton(
                    label: 'C',
                    buttonType: ButtonType.function,
                    onPressed: () {
                      ref.read(expressionProvider.notifier).state = '';
                    },
                  ),
                  CalcButton(
                    label: '()',
                    buttonType: ButtonType.function,
                    onPressed: () => _append(ref, '('),
                  ),
                  CalcButton(
                    label: '%',
                    buttonType: ButtonType.function,
                    onPressed: () => _append(ref, '%'),
                  ),
                  CalcButton(
                    label: '÷',
                    buttonType: ButtonType.operator,
                    onPressed: () => _append(ref, '/'),
                  ),
                  
                  // 두 번째 줄: 7, 8, 9, ×
                  CalcButton(
                    label: '7',
                    buttonType: ButtonType.number,
                    onPressed: () => _append(ref, '7'),
                  ),
                  CalcButton(
                    label: '8',
                    buttonType: ButtonType.number,
                    onPressed: () => _append(ref, '8'),
                  ),
                  CalcButton(
                    label: '9',
                    buttonType: ButtonType.number,
                    onPressed: () => _append(ref, '9'),
                  ),
                  CalcButton(
                    label: '×',
                    buttonType: ButtonType.operator,
                    onPressed: () => _append(ref, '*'),
                  ),
                  
                  // 세 번째 줄: 4, 5, 6, -
                  CalcButton(
                    label: '4',
                    buttonType: ButtonType.number,
                    onPressed: () => _append(ref, '4'),
                  ),
                  CalcButton(
                    label: '5',
                    buttonType: ButtonType.number,
                    onPressed: () => _append(ref, '5'),
                  ),
                  CalcButton(
                    label: '6',
                    buttonType: ButtonType.number,
                    onPressed: () => _append(ref, '6'),
                  ),
                  CalcButton(
                    label: '−',
                    buttonType: ButtonType.operator,
                    onPressed: () => _append(ref, '-'),
                  ),
                  
                  // 네 번째 줄: 1, 2, 3, +
                  CalcButton(
                    label: '1',
                    buttonType: ButtonType.number,
                    onPressed: () => _append(ref, '1'),
                  ),
                  CalcButton(
                    label: '2',
                    buttonType: ButtonType.number,
                    onPressed: () => _append(ref, '2'),
                  ),
                  CalcButton(
                    label: '3',
                    buttonType: ButtonType.number,
                    onPressed: () => _append(ref, '3'),
                  ),
                  CalcButton(
                    label: '+',
                    buttonType: ButtonType.operator,
                    onPressed: () => _append(ref, '+'),
                  ),
                  
                  // 다섯 번째 줄: ±, 0, ., =
                  CalcButton(
                    label: '±',
                    buttonType: ButtonType.number,
                    onPressed: () => _append(ref, '±'),
                  ),
                  CalcButton(
                    label: '0',
                    buttonType: ButtonType.number,
                    onPressed: () => _append(ref, '0'),
                  ),
                  CalcButton(
                    label: '.',
                    buttonType: ButtonType.number,
                    onPressed: () => _append(ref, '.'),
                  ),
                  CalcButton(
                    label: '=',
                    buttonType: ButtonType.equals,
                    onPressed: () {
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

