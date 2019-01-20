import 'package:flutter/material.dart';

abstract class ChessTimerEvent {}

class ResetEvent extends ChessTimerEvent {}

class PauseEvent extends ChessTimerEvent {}

class ResumeEvent extends ChessTimerEvent {}

class StopEvent extends ChessTimerEvent {
  final BuildContext context;
  StopEvent(this.context);
}

class TimerTickEvent extends ChessTimerEvent {}

class PlayerStoppedEvent extends ChessTimerEvent {
  final int triggeringPlayer;
  PlayerStoppedEvent(this.triggeringPlayer);
}