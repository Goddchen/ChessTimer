import 'package:chess_timer/common/localizations.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chess_timer/blocs/events.dart';
import 'package:chess_timer/blocs/bloc.dart';

class SettingsWidget extends StatelessWidget {
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
            onChange: (value) =>
                BlocProvider.of<ChessTimerBloc>(context).add(ResetEvent())),
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
        CheckboxPreference(
          AppLocalizations.of(context).get('settings_sound_last_seconds'),
          'sound_last_seconds',
          defaultVal: true,
        ),
        CheckboxPreference(
          AppLocalizations.of(context).get('settings_sound_time_up'),
          'sound_time_up',
          defaultVal: true,
        ),
      ]),
    );
  }
}
