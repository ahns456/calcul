import 'package:flutter/material.dart';

class CalcButton extends StatelessWidget {
  const CalcButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            // 버튼 패딩을 줄여서 텍스트가 더 잘 보이도록 함
            padding: const EdgeInsets.all(8.0),
            // 버튼 모서리를 약간 둥글게
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18, // 폰트 크기 지정
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
