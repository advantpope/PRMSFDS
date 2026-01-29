import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import '../app.dart';

class AppLocalizations {
  AppLocalizations(this.locale);
  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('sw', ''),
  ];

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, String>? _localizedStrings;

  Future<bool> load() async {
    final json = await DefaultAssetBundle.of(
      navigatorKey.currentContext!,
    ).loadString('lib/localization/arb/app_${locale.languageCode}.arb');

    _localizedStrings = Map<String, String>.from(jsonDecode(json));
    return true;
  }

  String translate(String key) {
    return _localizedStrings![key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (l) => l.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// Helper extension for easy access
extension LocalizationExtension on BuildContext {
  String tr(String key) {
    return AppLocalizations.of(this).translate(key);
  }
}
