import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers.dart';

// 버튼 타입 정의 - 이미지 참고한 색상 구분
enum ButtonType {
  number,     // 숫자 버튼 (회색)
  operator,   // 연산자 버튼 (주황색)
  function,   // 기능 버튼 (연한 회색)
  equals,     // 등호 버튼 (녹색)
}

class CalcButton extends ConsumerWidget {
  const CalcButton({
    required this.label,
    required this.onPressed,
    this.buttonType = ButtonType.number,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final ButtonType buttonType;

  // 햅틱 피드백 실행 함수
  void _performHapticFeedback(WidgetRef ref) {
    final hapticEnabled = ref.read(hapticProvider);
    if (hapticEnabled) {
      // 버튼 타입에 따라 다른 햅틱 피드백 적용
      switch (buttonType) {
        case ButtonType.equals:
          HapticFeedback.mediumImpact(); // 등호 버튼은 중간 강도
          break;
        case ButtonType.operator:
        case ButtonType.function:
          HapticFeedback.lightImpact(); // 연산자/기능 버튼은 가벼운 강도
          break;
        case ButtonType.number:
          HapticFeedback.selectionClick(); // 숫자 버튼은 선택 클릭
          break;
      }
    }
  }

  // 버튼 타입별 색상 정의
  Color _getBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    switch (buttonType) {
      case ButtonType.number:
        return isDark ? Colors.grey[800]! : Colors.grey[300]!;
      case ButtonType.operator:
        return Colors.orange[600]!;
      case ButtonType.function:
        return isDark ? Colors.grey[700]! : Colors.grey[400]!;
      case ButtonType.equals:
        return Colors.green[600]!;
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (buttonType) {
      case ButtonType.number:
      case ButtonType.function:
        return Theme.of(context).brightness == Brightness.dark 
            ? Colors.white 
            : Colors.black;
      case ButtonType.operator:
      case ButtonType.equals:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      button: true,
      label: label,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle, // 동그란 버튼
          color: _getBackgroundColor(context),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _performHapticFeedback(ref); // 햅틱 피드백 실행
              onPressed(); // 원래 콜백 실행
            },
            borderRadius: BorderRadius.circular(50), // 원형 ripple 효과
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 24, // 더 큰 폰트
                  fontWeight: FontWeight.w500,
                  color: _getTextColor(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
