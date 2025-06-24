import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const _localizedStrings = {
    'en': {
      'appTitle': 'Material You Calculator',
      'settings': 'Settings',
      'darkMode': 'Dark Mode',
      'hapticFeedback': 'Haptic Feedback',
      'sound': 'Sound',
    },
    'ko': {
      'appTitle': '머티리얼 유 계산기',
      'settings': '설정',
      'darkMode': '다크 모드',
      'hapticFeedback': '진동 피드백',
      'sound': '사운드',
    },
  };

  String get appTitle => _localizedStrings[locale.languageCode]!['appTitle']!;
  String get settings => _localizedStrings[locale.languageCode]!['settings']!;
  String get darkMode => _localizedStrings[locale.languageCode]!['darkMode']!;
  String get hapticFeedback =>
      _localizedStrings[locale.languageCode]!['hapticFeedback']!;
  String get sound => _localizedStrings[locale.languageCode]!['sound']!;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ko'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
