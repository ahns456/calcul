import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/use_cases/calculate.dart';
import '../utils/number_formatter.dart';

/// Holds the current math expression.
final expressionProvider = StateProvider<String>((ref) => '');

/// 표시용 수식 (사용자 친화적인 기호로 변환)
final displayExpressionProvider = Provider<String>((ref) {
  final expression = ref.watch(expressionProvider);
  return NumberFormatter.formatExpressionForDisplay(expression);
});

/// Holds the current result string.
final resultProvider = Provider<String>((ref) {
  final expression = ref.watch(expressionProvider);
  if (expression.isEmpty) {
    return '0';
  }
  
  // 미완성된 식인지 확인 (연산자로 끝나거나 괄호가 닫히지 않은 경우)
  if (_isIncompleteExpression(expression)) {
    return '';
  }
  
  final calculator = ref.watch(calculateUseCaseProvider);
  try {
    final value = calculator.call(expression);
    if (value.isInfinite || value.isNaN) {
      return 'Err';
    }
    return NumberFormatter.formatNumberWithCommas(value);
  } catch (_) {
    return 'Err';
  }
});

/// 미완성된 수식인지 확인하는 함수
bool _isIncompleteExpression(String expression) {
  if (expression.isEmpty) return false;
  
  // 연산자로 끝나는 경우
  if (RegExp(r'[+\-*/]$').hasMatch(expression)) {
    return true;
  }
  
  // 열린 괄호의 개수가 닫힌 괄호보다 많은 경우
  int openParens = expression.split('(').length - 1;
  int closeParens = expression.split(')').length - 1;
  if (openParens > closeParens) {
    return true;
  }
  
  return false;
}

/// App theme mode state.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

/// Haptic feedback toggle.
final hapticProvider = StateProvider<bool>((ref) => true);

/// Provides the calculation use case.
final calculateUseCaseProvider = Provider<CalculateUseCase>(
  (ref) => CalculateUseCase(),
);
