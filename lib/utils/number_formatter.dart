import 'package:intl/intl.dart';

/// 숫자 포맷팅 관련 유틸리티 클래스
class NumberFormatter {
  /// 수식을 표시용으로 변환하는 함수
  static String formatExpressionForDisplay(String expression) {
    if (expression.isEmpty) return expression;
    
    // 먼저 연산자를 사용자 친화적인 기호로 변환
    String result = expression
        .replaceAll('*', '×')
        .replaceAll('/', '÷')
        .replaceAll('-', '−');
    
    // 숫자에 천 단위 구분 쉼표 추가
    // 정규식으로 숫자 패턴을 찾아서 쉼표를 추가
    result = result.replaceAllMapped(
      RegExp(r'\d+\.?\d*'),
      (Match match) {
        final numberStr = match.group(0)!;
        final number = double.tryParse(numberStr);
        
        if (number == null) return numberStr;
        
        // 정수인 경우와 소수인 경우를 구분해서 포맷팅
        if (number == number.toInt()) {
          // 정수인 경우
          final formatter = NumberFormat('#,##0');
          return formatter.format(number.toInt());
        } else {
          // 소수인 경우
          final formatter = NumberFormat('#,##0.#########');
          return formatter.format(number);
        }
      },
    );
    
    return result;
  }

  /// 숫자에 천 단위 구분 쉼표를 추가하는 함수
  static String formatNumberWithCommas(double value) {
    final formatter = NumberFormat('#,##0.#########');
    return formatter.format(value);
  }

  /// 결과 문자열을 포맷팅하는 함수 (이미 문자열인 경우)
  static String formatResultString(String result) {
    if (result.isEmpty || result == 'Err' || result == '0') {
      return result;
    }
    
    final number = double.tryParse(result);
    if (number != null) {
      return formatNumberWithCommas(number);
    }
    
    return result;
  }
}
