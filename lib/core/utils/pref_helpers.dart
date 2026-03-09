import 'package:shared_preferences/shared_preferences.dart';

class PrefHelpers {
  final bool isFirstTime = true;

  Future<void> saveFirstTime(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', value);
  }

  Future<bool> getFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstTime') ?? true;
  }
}
