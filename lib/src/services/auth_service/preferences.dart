import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? preferences;

Future initializePreference() async {
  preferences = await SharedPreferences.getInstance();
}
