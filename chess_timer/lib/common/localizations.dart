import 'dart:async';

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
      'app_name': 'Chess Timer',
      'statistics': 'Statistics',
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
      'settings_animate_last_seconds': 'Animate on last turn seconds',
      'settings_sound_time_up': 'Play sound when time is up',
      'settings_sound_last_seconds': 'Play sound on last turn seconds',
      'stats_total_game_time': 'Total time of the game',
      'stats_turns': 'Total moves',
      'stats_avg_turn_time': 'Average time per move',
    },
    'de': {
      'app_name': 'Schach-Timer',
      'statistics': 'Statistiken',
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
      'settings_animate_last_seconds': 'Animation in den letzten Sekunden',
      'settings_sound_time_up': 'Sound bei Ablauf der Zeit',
      'settings_sound_last_seconds': 'Sound in den letzten Sekunden',
      'stats_total_game_time': 'Gesamtzeit des Spiels',
      'stats_turns': 'Spielzüge',
      'stats_avg_turn_time': 'Durchschnittliche Zugzeit',
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
