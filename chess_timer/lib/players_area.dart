import 'package:flutter/material.dart';

class PlayersArea extends StatelessWidget {
  final Function clickedCallback;
  final bool _isActive;
  final int _timeSeconds;

  const PlayersArea({Key key, this.clickedCallback, isActive, time})
      : _isActive = isActive,
        _timeSeconds = time,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: MaterialButton(
        color: _isActive ? Colors.lightBlue : Colors.grey,
        onPressed: () => clickedCallback(),
        child: Text(_timeSeconds.toString()),
      ),
    );
  }
}
