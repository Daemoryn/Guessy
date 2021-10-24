import 'package:flutter/foundation.dart';

class DynamicTheme with ChangeNotifier {
  bool isDarkMode = true;
  getDarkMode() => isDarkMode;
  void changeDarkMode(isDarkMode) {
    this.isDarkMode = isDarkMode;
    notifyListeners();
  }
}