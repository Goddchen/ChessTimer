import 'package:chess_timer/blocs/events.dart';
import 'package:chess_timer/common/app_colors.dart';
import 'package:chess_timer/ui/settings.dart';
import 'package:flutter/material.dart';
import 'package:chess_timer/blocs/bloc.dart';

class MiddleArea extends StatelessWidget {
  final bool _isRunning;
  final ChessTimerBloc _bloc;

  MiddleArea({bloc, isRunning})
      : this._isRunning = isRunning,
        this._bloc = bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.homeBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
            child: Icon(
              _isRunning ? Icons.pause : Icons.play_arrow,
              size: 48,
            ),
            onTap: () {
              if (_isRunning) {
                _bloc.add(PauseEvent());
              } else {
                _bloc.add(ResumeEvent());
              }
            },
          ),
          InkWell(
            child: Icon(Icons.refresh, size: 44),
            onTap: () => _bloc.add(ResetEvent()),
          ),
          InkWell(
            child: Icon(Icons.stop, size: 48),
            onTap: () => _bloc.add(StopEvent(context)),
          ),
          InkWell(
            child: Icon(Icons.settings, size: 40),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsWidget())),
          ),
        ],
      ),
    );
  }
}
