import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calcul/application/providers.dart';

void main() {
  test('expression updates correctly', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(expressionProvider.notifier).state = '1+1';
    expect(container.read(expressionProvider), '1+1');
  });

  test('theme toggles', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(themeModeProvider.notifier).state = ThemeMode.dark;
    expect(container.read(themeModeProvider), ThemeMode.dark);
  });
}
