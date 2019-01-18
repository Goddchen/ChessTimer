import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:chess_timer/localizations.dart';

class SettingsWidget extends StatelessWidget {

  final Function _onPrefsChanged;

  const SettingsWidget(this._onPrefsChanged);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).get('settings')),
      ),
      body: PreferencePage([
        PreferenceTitle('General'),
        DropdownPreference(
            AppLocalizations.of(context).get('settings_turn_time_title'),
            'turn_time',
            defaultVal: 10,
            values: [10, 15, 20, 30, 45, 60],
            desc: AppLocalizations.of(context).get('settings_turn_time_desc'),
            displayValues: ['10', '15', '20', '30', '45', '60'],
            onChange: (value) => _onPrefsChanged()),
        PreferenceTitle(AppLocalizations.of(context).get('settings_feedback')),
        CheckboxPreference(
          AppLocalizations.of(context).get('settings_vibrate_on_end'),
          'vibrate_turn_end',
          defaultVal: true,
        ),
        CheckboxPreference(
          AppLocalizations.of(context).get('settings_vibrate_on_last_seconds'),
          'vibrate_last_seconds',
          defaultVal: true,
        ),
        CheckboxPreference(
          AppLocalizations.of(context).get('settings_vibrate_time_up'),
          'vibrate_on_time_up',
          defaultVal: true,
        ),
        CheckboxPreference(
          AppLocalizations.of(context).get('settings_animate_last_seconds'),
          'animate_last_seconds',
          defaultVal: true,
        ),
      ]),
    );
  }
}
