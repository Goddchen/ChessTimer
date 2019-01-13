import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  static Map<String, Map<String, String>> localizedValues = {
    'en': {
      'total_time': 'Total time',
      'turns': 'Turns',
      'avg_turn': 'Avg turn',
      'settings': 'Settings',
      'settings_general': 'General',
      'settings_turn_time_title': 'Turn Time',
      'settings_turn_time_desc': 'Turn time in seconds',
      'settings_feedback': 'Feedback',
      'settings_vibrate_on_end': 'Vibrate on turn end',
      'settings_vibrate_on_last_seconds': 'Vibrate on last turn seconds',
      'settings_vibrate_time_up': 'Vibrate when time is up',
    },
    'de': {
      'total_time': 'Gesamtzeit',
      'turns': 'Züge',
      'avg_turn': 'Durchschn. Zug',
      'settings': 'Einstellungen',
      'settings_general': 'Allgemein',
      'settings_turn_time_title': 'Zugzeit',
      'settings_turn_time_desc': 'Zugzeit in Sekunden',
      'settings_feedback': 'Feedback',
      'settings_vibrate_on_end': 'Vibration bei Zugende',
      'settings_vibrate_on_last_seconds': 'Vibration in den letzten Sekunden',
      'settings_vibrate_time_up': 'Vibration bei Ablauf der Zeit',
    },
  };

  String get(String key) =>
      localizedValues[locale.languageCode][key] ?? 'localization_not_found';
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.localizedValues.containsKey(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture<AppLocalizations>(AppLocalizations(locale));

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
