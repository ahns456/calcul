import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/history_repository_impl.dart';
import '../domain/models/history_entry.dart';
import 'history_notifier.dart';

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

/// History repository provider backed by Hive.
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final box = Hive.box<HistoryEntry>('history');
  return HiveHistoryRepository(box);
});

/// Calculator history state.
final historyListProvider =
    StateNotifierProvider<HistoryNotifier, List<HistoryEntry>>((ref) {
  final repo = ref.watch(historyRepositoryProvider);
  return HistoryNotifier(repo);
});
