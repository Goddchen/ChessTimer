import 'package:flutter/material.dart';

class PlayersArea extends StatelessWidget {
  final Function clickedCallback;
  final bool _isActive;
  final int _time; // in seconds

  const PlayersArea({Key key, this.clickedCallback, isActive, time})
      : _isActive = isActive,
        _time = time,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: MaterialButton(
        color: _isActive ? Colors.lightBlue : Colors.grey,
        onPressed: () => clickedCallback(),
        child: Text(_time.toString()),
      ),
    );
  }
}

/* class _PlayerState extends State<PlayersArea> {
  int _playersTime; // in seconds
  CountdownTimer timer;

  @override
  void initState() {
    super.initState();
    if (widget._isActive) {
      _activateTimer();
    } else {
      _deactivateTimer();
    }
  }

  void _activateTimer() {
    setState(() {
      _playersTime = widget._playersTimeStart;
    });
    timer = CountdownTimer(
      Duration(seconds: _playersTime, milliseconds: 500),
      Duration(seconds: 1),
    );
    timer.listen((timer) {
      setState(() {
        _playersTime = timer.remaining.inSeconds;
        if (timer.remaining.isNegative) timer.cancel();
      });
    });
  }

  void _deactivateTimer() {
    timer?.cancel();
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
 */
