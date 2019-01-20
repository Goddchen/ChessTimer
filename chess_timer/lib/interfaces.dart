import 'package:preferences/preferences.dart';
import 'package:vibrate/vibrate.dart';

export 'package:vibrate/vibrate.dart';

abstract class VibrateInterface {
  void feedback(FeedbackType feedbackType);
}

class VibrateImpl implements VibrateInterface {
  @override
  void feedback(FeedbackType feedbackType) {
    Vibrate.feedback(feedbackType);
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
