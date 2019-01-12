import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'main.dart';

class SettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ChessTimerState state =
        context.ancestorStateOfType(TypeMatcher<ChessTimerState>());

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: PreferencePage([
        PreferenceTitle('General'),
        DropdownPreference('Turn Time', 'turn_time',
            defaultVal: 10,
            values: [10, 15, 20, 30, 45, 60],
            desc: 'Turn time in seconds',
            displayValues: ['10', '15', '20', '30', '45', '60'],
            onChange: (value) => state.setNewTurnTime(value)),
      ]),
    );
  }
}
