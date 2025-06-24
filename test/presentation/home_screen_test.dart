import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calcul/presentation/screens/home_screen.dart';

void main() {
  testWidgets('renders calculator buttons', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: HomeScreen())));

    expect(find.text('1'), findsOneWidget);
    expect(find.text('+'), findsOneWidget);
  });
}
