import 'package:flutter/material.dart';

class PlayersArea extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlayerState();
}

class _PlayerState extends State<PlayersArea> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: MaterialButton(
        color: Colors.grey,
        onPressed: () => {},
        child: Text('Player Area'),
      ),
    );
  }
}
