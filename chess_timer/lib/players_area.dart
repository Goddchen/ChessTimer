import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class PlayersArea extends StatelessWidget {
  final Function clickedCallback;
  final bool _isActive;
  final num _timeSeconds;

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
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  '${NumberFormat('00').format(((_timeSeconds ?? 10) / 60).floor())}:${NumberFormat('00').format(((_timeSeconds ?? 10) % 60))}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 64,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Transform.rotate(
                  angle: pi,
                  child: Text(
                    '${NumberFormat('00').format(((_timeSeconds ?? 10) / 60).floor())}:${NumberFormat('00').format(((_timeSeconds ?? 10) % 60))}',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
