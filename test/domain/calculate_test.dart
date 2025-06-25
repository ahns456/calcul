import 'package:flutter_test/flutter_test.dart';
import 'package:calcul/domain/use_cases/calculate.dart';

void main() {
  final calculator = CalculateUseCase();

  test('simple addition', () {
    expect(calculator.call('1+2'), equals(3));
  });

  test('parentheses and precedence', () {
    expect(calculator.call('2*(3+4)'), equals(14));
  });

  test('unary minus and decimals', () {
    expect(calculator.call('-1.5+2.5'), closeTo(1.0, 0.0001));
  });

  test('complex expression', () {
    expect(calculator.call('3+4*2/(1-5)'), equals(1));
  });

  test('invalid expression throws', () {
    expect(() => calculator.call('1+'), throwsFormatException);
  });
}
