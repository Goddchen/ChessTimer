import 'package:flutter/material.dart';
import 'package:quiver/async.dart';

class PlayersArea extends StatefulWidget {
  final Function f;
  const PlayersArea({Key key, this.f}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerState();
}

class _PlayerState extends State<PlayersArea> {
  int _timerSeconds;
  bool _active;

  void activate(int time) {
    setState(() {
      _timerSeconds = time;
      _active = true;
    });
    CountdownTimer(Duration(seconds: _timerSeconds, milliseconds: 500),
            Duration(seconds: 1))
        .listen((timer) {
      setState(() {
        _timerSeconds = timer.remaining.inSeconds;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: MaterialButton(
        color: Colors.grey,
        onPressed: () {
          activate(10);
          widget.f();
        },
        child: Text(_timerSeconds.toString()),
      ),
    );
  }
}
