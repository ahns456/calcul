import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final darkMode = ref.watch(themeModeProvider) == ThemeMode.dark;
    final haptic = ref.watch(hapticProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(l10n.darkMode),
            value: darkMode,
            onChanged: (value) {
              ref.read(themeModeProvider.notifier).state =
                  value ? ThemeMode.dark : ThemeMode.light;
            },
          ),
          SwitchListTile(
            title: Text(l10n.hapticFeedback),
            value: haptic,
            onChanged: (value) {
              ref.read(hapticProvider.notifier).state = value;
            },
          ),
        ],
      ),
    );
  }
}
