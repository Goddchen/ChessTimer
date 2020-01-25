import 'package:preferences/preferences.dart';
import 'package:vibration/vibration.dart';

abstract class VibrateInterface {
  void feedback(FeedbackType feedbackType);
}

enum FeedbackType { short, long }

class VibrateImpl implements VibrateInterface {
  @override
  void feedback(FeedbackType feedbackType) {
    switch (feedbackType) {
      case FeedbackType.short:
        Vibration.vibrate(duration: 200);
        break;
      case FeedbackType.long:
        Vibration.vibrate(duration: 1000);
        break;
    }
  }
}

class PrefServiceInterface {
  void init() {}

  bool getBool(String key) {
    return true;
  }

  void setBool(String key, bool value) {}
  int getInt(String key) {
    return 0;
  }

  void setInt(String key, int value) {}
}

class PrefServiceImpl implements PrefServiceInterface {
  @override
  bool getBool(String key) => PrefService.getBool(key);

  @override
  int getInt(String key) => PrefService.getInt(key);

  @override
  void setBool(String key, bool value) {
    PrefService.setBool(key, value);
  }

  @override
  void setInt(String key, int value) {
    PrefService.setInt(key, value);
  }

  @override
  void init() {
    PrefService.init();
  }
}
