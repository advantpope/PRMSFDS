import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('sw', ''),
  ];

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, String>? _localizedStrings;

  Future<bool> load() async {
    // For now, use hardcoded strings
    _localizedStrings = {
      'appTitle': 'Property Tax System',
      'properties': 'Properties',
      'ownership': 'Ownership',
      'login': 'Login',
      'logout': 'Logout',
    };
    return true;
  }

  String translate(String key) {
    // Return key if translation not found
    return _localizedStrings?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'sw'].contains(locale.languageCode);
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
