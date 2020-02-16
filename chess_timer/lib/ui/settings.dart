import 'package:chess_timer/common/app_colors.dart';
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
        backgroundColor: AppColors.player_area_inactive,
        brightness: Brightness.light,
        textTheme: TextTheme(
            headline6: TextStyle(
          color: Colors.black,
          fontSize: 24,
        )),
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(AppLocalizations.of(context).get('settings')),
      ),
      body: Container(
        color: AppColors.homeBackground,
        child: PreferencePage([
          _buildHeading(AppLocalizations.of(context).get('settings_general')),
          DropdownPreference(
              AppLocalizations.of(context).get('settings_turn_time_title'),
              'turn_time',
              defaultVal: 10,
              values: [10, 15, 20, 30, 45, 60],
              desc: AppLocalizations.of(context).get('settings_turn_time_desc'),
              displayValues: ['10', '15', '20', '30', '45', '60'],
              onChange: (value) =>
                  BlocProvider.of<ChessTimerBloc>(context).add(ResetEvent())),
          _buildHeading(AppLocalizations.of(context).get('settings_feedback')),
          _buildCheckBox(
            title: AppLocalizations.of(context).get('settings_vibrate_on_end'),
            localKey: 'vibrate_turn_end',
          ),
          _buildCheckBox(
            title: AppLocalizations.of(context)
                .get('settings_vibrate_on_last_seconds'),
            localKey: 'vibrate_last_seconds',
          ),
          _buildCheckBox(
            title: AppLocalizations.of(context).get('settings_vibrate_time_up'),
            localKey: 'vibrate_on_time_up',
          ),
          _buildCheckBox(
            title: AppLocalizations.of(context)
                .get('settings_animate_last_seconds'),
            localKey: 'animate_last_seconds',
          ),
          _buildCheckBox(
            title:
                AppLocalizations.of(context).get('settings_sound_last_seconds'),
            localKey: 'sound_last_seconds',
          ),
          _buildCheckBox(
            title: AppLocalizations.of(context).get('settings_sound_time_up'),
            localKey: 'sound_time_up',
          ),
        ]),
      ),
    );
  }

  Widget _buildHeading(title) => Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                AppColors.player_area_inactive.withOpacity(0.8),
                AppColors.player_area_inactive_border.withOpacity(0.7),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: PreferenceTitle(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
      );

  Widget _buildCheckBox({title, localKey}) => Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          CheckboxPreference(
            title,
            localKey,
            defaultVal: true,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 18),
            child: Container(
              height: 1,
              color: Colors.black.withOpacity(0.1),
            ),
          ),
        ],
      );
}
