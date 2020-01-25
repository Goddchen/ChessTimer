// import 'dart:typed_data';
// import 'package:flutter/src/services/asset_bundle.dart';
// import 'package:chess_timer/blocs/bloc.dart';
// import 'package:chess_timer/interfaces.dart';
// import 'package:soundpool/soundpool.dart';
// import 'dart:async';
// import 'package:flutter/services.dart';
import 'package:test/test.dart';

void main() {
  test('placeholder', () {
    expect(true, 2 == 2);
  });
}
//   test('Test initial state', () {
//     var bloc = ChessTimerBloc(
//         PrefServiceMock(), SoundpoolMock(), AssetBundleMock(), VibrateMock());
//     expect(bloc.currentState.playerAtTurn, 0);
//     expect(bloc.currentState.playerTime, [0, 20, 20]);
//     bloc.currentState.stopwatches
//         .forEach((sw) => expect(sw.elapsed.inSeconds, 0));
//     expect(bloc.currentState.turnCounter, [0, 0, 0]);
//     expect(bloc.currentState.turnTimeSeconds, 20);
//   });
//   test('Test player stopped events', () async {
//     var bloc = ChessTimerBloc(
//         PrefServiceMock(), SoundpoolMock(), AssetBundleMock(), VibrateMock());
//     bloc.dispatch(PlayerStoppedEvent(1)); // player 1 starts game
//     bloc.dispatch(
//         PlayerStoppedEvent(1)); // player 1 stops his turn, player 2's turn
//     bloc.dispatch(
//         PlayerStoppedEvent(1)); // player 1 clicks stop, nothing changes
//     bloc.dispatch(
//         PlayerStoppedEvent(2)); // player 2 stops this turn, player 1's turn
//     List<ChessTimerState> states = await bloc.state.take(5).toList();
//     expect(states[0].playerAtTurn, 0);
//     expect(states[1].playerAtTurn, 1);
//     expect(states[2].playerAtTurn, 2);
//     expect(states[3].playerAtTurn, 2);
//     expect(states[4].playerAtTurn, 1);
//   });
//   test('Test reset event', () async {
//     var bloc = ChessTimerBloc(
//         PrefServiceMock(), SoundpoolMock(), AssetBundleMock(), VibrateMock());
//     bloc.dispatch(PlayerStoppedEvent(1));
//     bloc.dispatch(ResetEvent());
//     List<ChessTimerState> states = await bloc.state.take(3).toList();
//     expect(states[0].playerAtTurn, 0);
//     expect(states[1].playerAtTurn, 1);
//     expect(states[2].playerAtTurn, 0);
//   });

//   test('Test changing turn time', () async {
//     var prefService = PrefServiceMock();
//     var bloc = ChessTimerBloc(
//         prefService, SoundpoolMock(), AssetBundleMock(), VibrateMock());
//     prefService.setInt('turn_time', 30);
//     bloc.dispatch(ResetEvent());
//     List<ChessTimerState> states = await bloc.state.take(2).toList();
//     expect(states[0].turnTimeSeconds, 20);
//     expect(states[1].turnTimeSeconds, 30);
//   });

//   test('Test timer ticks', () async {
//     var prefService = PrefServiceMock();
//     prefService.setInt('turn_time', 5);
//     var bloc = ChessTimerBloc(
//         prefService, SoundpoolMock(), AssetBundleMock(), VibrateMock());
//     bloc.dispatch(PlayerStoppedEvent(1));
//     List<ChessTimerState> states = await bloc.state.take(7).toList();
//     expect(states[0].playerTime[1], 5);
//     expect(states[1].playerTime[1], 5);
//     expect(states[2].playerTime[1], 4);
//     expect(states[3].playerTime[1], 3);
//     expect(states[4].playerTime[1], 2);
//     expect(states[5].playerTime[1], 1);
//     expect(states[6].playerTime[1], 0);

//     expect(states[0].playerTime[2], 5);
//     expect(states[1].playerTime[2], 5);
//     expect(states[2].playerTime[2], 5);
//     expect(states[3].playerTime[2], 5);
//     expect(states[4].playerTime[2], 5);
//     expect(states[5].playerTime[2], 5);
//     expect(states[6].playerTime[2], 5);
//   });

//   test('Test pause event', () async {
//     BlocSupervisor().delegate = LogAllBlocDelegate();
//     var bloc = ChessTimerBloc(
//         PrefServiceMock(), SoundpoolMock(), AssetBundleMock(), VibrateMock());
//     bloc.dispatch(PlayerStoppedEvent(1));
//     await Future.delayed(Duration(seconds: 3, milliseconds: 500));
//     bloc.dispatch(PauseEvent());
//     await Future.delayed(Duration(seconds: 3));
//     expect(bloc.currentState.playerTime[1], 17);
//     expect(
//         bloc.currentState.stopwatches
//             .map((sw) => sw.elapsed.inSeconds)
//             .reduce((a, b) => a + b),
//         3);
//   });

//   test('Test total time keeps running after turn time is up', () async {
//     BlocSupervisor().delegate = LogAllBlocDelegate();
//     var prefService = PrefServiceMock();
//     prefService.setInt('turn_time', 2);
//     var bloc = ChessTimerBloc(
//         prefService, SoundpoolMock(), AssetBundleMock(), VibrateMock());
//     bloc.dispatch(PlayerStoppedEvent(1));
//     await Future.delayed(Duration(seconds: 5));
//     expect(bloc.currentState.playerTime[1], 0);
//     expect(
//         bloc.currentState.stopwatches
//             .map((sw) => sw.elapsed.inSeconds)
//             .reduce((a, b) => a + b),
//         5);
//   });
// }

// class PrefServiceMock implements PrefServiceInterface {
//   Map<String, dynamic> _map = {'turn_time': 20};

//   @override
//   bool getBool(String key) => true;

//   @override
//   int getInt(String key) => _map[key];

//   @override
//   void init() {}

//   @override
//   void setBool(String key, bool value) {}

//   @override
//   void setInt(String key, int value) {
//     _map[key] = value;
//   }
// }

// class SoundpoolMock implements Soundpool {
//   @override
//   void dispose() {}

//   @override
//   Future release() {
//     return null;
//   }

//   @override
//   Future<void> resume(int streamId) {
//     return null;
//   }

//   @override
//   Future setVolume(
//       {int soundId,
//       int streamId,
//       double volume,
//       double volumeLeft,
//       double volumeRight}) {
//     return null;
//   }

//   @override
//   Future<void> stop(int streamId) {
//     return null;
//   }

//   @override
//   StreamType get streamType => null;

//   @override
//   Future<int> load(ByteData rawSound,
//       {int priority = _DEFAULT_SOUND_PRIORITY}) {
//     return null;
//   }

//   @override
//   Future<int> loadAndPlay(ByteData rawSound,
//       {int priority = _DEFAULT_SOUND_PRIORITY,
//       int repeat = 0,
//       double rate = 1.0}) {
//     return null;
//   }

//   @override
//   Future<int> loadAndPlayUint8List(Uint8List rawSound,
//       {int priority = _DEFAULT_SOUND_PRIORITY,
//       int repeat = 0,
//       double rate = 1.0}) {
//     return null;
//   }

//   @override
//   Future<int> loadAndPlayUri(String uri,
//       {int priority = _DEFAULT_SOUND_PRIORITY,
//       int repeat = 0,
//       double rate = 1.0}) {
//     return null;
//   }

//   @override
//   Future<int> loadUint8List(Uint8List rawSound,
//       {int priority = _DEFAULT_SOUND_PRIORITY}) {
//     return null;
//   }

//   @override
//   Future<int> loadUri(String uri, {int priority = _DEFAULT_SOUND_PRIORITY}) {
//     return null;
//   }

//   @override
//   Future<void> pause(int streamId) {
//     return null;
//   }

//   @override
//   Future<int> play(int soundId, {int repeat = 0, double rate = 1.0}) {
//     return null;
//   }

//   @override
//   Future<AudioStreamControl> playWithControls(int soundId,
//       {int repeat = 0, double rate = 1.0}) {
//     return null;
//   }

//   @override
//   Future setRate({int streamId, double playbackRate}) {
//     return null;
//   }
// }

// class AssetBundleMock implements AssetBundle {
//   @override
//   void evict(String key) {}

//   @override
//   Future<ByteData> load(String key) {
//     return Future.value(null);
//   }

//   @override
//   Future<String> loadString(String key, {bool cache = true}) {
//     return Future.value(null);
//   }

//   @override
//   Future<T> loadStructuredData<T>(
//       String key, Future<T> Function(String value) parser) {
//     return null;
//   }
// }

// class VibrateMock implements VibrateInterface {
//   @override
//   void feedback(FeedbackType feedbackType) {}
// }
