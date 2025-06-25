import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calcul/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:calcul/presentation/screens/home_screen.dart';
import 'package:calcul/presentation/widgets/calc_button.dart';

void main() {
  testWidgets('renders calculator buttons', (tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(
        home: HomeScreen(),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [Locale('en')],
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(CalcButton), findsWidgets);
  });

  testWidgets('shows real time result', (tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(
        home: HomeScreen(),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [Locale('en')],
      ),
    ));

    await tester.tap(find.widgetWithText(CalcButton, '1'));
    await tester.pump();
    await tester.tap(find.widgetWithText(CalcButton, '+'));
    await tester.pump();
    await tester.tap(find.widgetWithText(CalcButton, '2'));
    await tester.pump();

    expect(find.text('3'), findsOneWidget);
  });
}
