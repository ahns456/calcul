import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the current math expression.
final expressionProvider = StateProvider<String>((ref) => '');

/// Holds the current result string.
final resultProvider = StateProvider<String>((ref) => '0');

/// App theme mode state.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// Haptic feedback toggle.
final hapticProvider = StateProvider<bool>((ref) => true);

/// Sound feedback toggle.
final soundProvider = StateProvider<bool>((ref) => true);
