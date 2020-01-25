import 'package:chess_timer/common/interfaces.dart';
import 'package:chess_timer/common/localizations.dart';
import 'package:chess_timer/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preferences/preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:chess_timer/blocs/bloc.dart';
import 'package:soundpool/soundpool.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  await PrefService.init();
  BlocSupervisor.delegate = LogAllBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChessTimerBloc>(
      create: (context) {
        return ChessTimerBloc(PrefServiceImpl(),
            Soundpool(streamType: StreamType.music), rootBundle, VibrateImpl());
      },
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('de'),
        ],
        title: AppLocalizations.of(context)?.get('app_name') ?? 'Chess Timer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}
