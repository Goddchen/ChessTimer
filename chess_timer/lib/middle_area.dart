import 'package:flutter/material.dart';
import 'settings.dart';
import 'main.dart';

class MiddleArea extends StatelessWidget {
  final bool _isRunning;

  const MiddleArea(this._isRunning);

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
            Icons.settings,
            size: 48,
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsWidget()));
          },
        ),
      ],
    );
  }
}
