import 'package:flutter/material.dart';
import 'package:chess_timer/settings.dart';
import 'package:chess_timer/main.dart';

class MiddleArea extends StatelessWidget {
  final bool _isRunning;
  final Function _onPrefsChanged;

  const MiddleArea(this._isRunning, this._onPrefsChanged);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InkWell(
          child: Icon(
            _isRunning ? Icons.pause : Icons.play_arrow,
            size: 48,
          ),
          onTap: () {
            ChessTimerState state =
                context.ancestorStateOfType(TypeMatcher<ChessTimerState>());
            if (_isRunning) {
              state.pause();
            } else {
              state.resume();
            }
          },
        ),
        InkWell(
          child: Icon(
            Icons.refresh,
            size: 48,
          ),
          onTap: () {
            ChessTimerState state =
                context.ancestorStateOfType(TypeMatcher<ChessTimerState>());
            state.reset();
          },
        ),
        InkWell(
          child: Icon(
            Icons.stop,
            size: 48,
          ),
          onTap: () {
            ChessTimerState state =
                context.ancestorStateOfType(TypeMatcher<ChessTimerState>());
            state.stop();
          },
        ),
        InkWell(
          child: Icon(
            Icons.settings,
            size: 48,
          ),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SettingsWidget(_onPrefsChanged))),
        ),
      ],
    );
  }
}
