import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  Future<bool>? isDarkMode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var user = preferences.getBool("darkmode-heposta-user");
    return user == null ? false : user;
  }
}
