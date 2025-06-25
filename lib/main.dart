import 'package:flutter/material.dart';
import "package:flutter_localizations/flutter_localizations.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'application/providers.dart';
import 'application/history_provider.dart';
import 'data/history_repository.dart';
import 'l10n/app_localizations.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/history_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final repo = HistoryRepository();
  await repo.init();
  runApp(
    ProviderScope(
      overrides: [historyRepositoryProvider.overrideWithValue(repo)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ko')],
      themeMode: themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      routes: {
        '/': (_) => const HomeScreen(),
        '/history': (_) => const HistoryScreen(),
      },
      initialRoute: '/',
    );
  }
}
