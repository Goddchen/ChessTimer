import 'package:flutter/material.dart';
import 'package:chess_timer/settings.dart';
import 'package:chess_timer/blocs/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MiddleArea extends StatelessWidget {
  final bool _isRunning;

  const MiddleArea(this._isRunning);

  @override
  Widget build(BuildContext context) {
    ChessTimerBloc bloc = BlocProvider.of<ChessTimerBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InkWell(
          child: Icon(
            _isRunning ? Icons.pause : Icons.play_arrow,
            size: 48,
          ),
          onTap: () {
            if (_isRunning) {
              bloc.dispatch(PauseEvent());
            } else {
              bloc.dispatch(ResumeEvent());
            }
          },
        ),
        InkWell(
          child: Icon(
            Icons.refresh,
            size: 48,
          ),
          onTap: () => bloc.dispatch(ResetEvent()),
        ),
        InkWell(
          child: Icon(
            Icons.stop,
            size: 48,
          ),
          onTap: () => bloc.dispatch(StopEvent(context)),
        ),
        InkWell(
          child: Icon(
            Icons.settings,
            size: 48,
          ),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => SettingsWidget())),
        ),
      ],
    );
  }
}
