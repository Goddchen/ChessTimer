import 'package:flutter/material.dart';
import 'package:quiver/async.dart';

class PlayersArea extends StatefulWidget {
  final Function clickedCallback;
  final bool _isActive;
  final int _playersTimeStart;  // in seconds

  const PlayersArea({Key key, this.clickedCallback, isActive, playersTimeStart}) :
     _isActive = isActive,  _playersTimeStart = playersTimeStart, super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerState();
}

class _PlayerState extends State<PlayersArea> {
  int _playersTime;  // in seconds
  CountdownTimer timer;

  void _activateTimer() {
    setState(() {
      _playersTime = widget._playersTimeStart;
    });
    timer = CountdownTimer(Duration(seconds: _playersTime, milliseconds: 500),
            Duration(seconds: 1));
    timer.listen((timer) {
      setState(() {
        _playersTime = timer.remaining.inSeconds;
      });
    });
  }

  void _deactivateTimer() {
    if (timer != null) {
      timer.cancel();
    }
  }

  int _getRemainingTime() {
    if (timer != null) {
      return timer.remaining.inSeconds;
    } else if (_playersTime != null) {
      return _playersTime;
    }
    return widget._playersTimeStart;
  }

  @override
  Widget build(BuildContext context) {
    if (widget._isActive) {
      _activateTimer();
    } else {
      _deactivateTimer();
    }

    return Container(
      constraints: BoxConstraints.expand(),
      child: MaterialButton(
        color: widget._isActive ? Colors.grey : Colors.lightBlue,
        onPressed: () {
          widget.clickedCallback(_getRemainingTime());
        },
        child: Text(_playersTime.toString()),
      ),
    );
  }
}
