import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static const String positionKey = 'user_position';
  
  // Save user position
  static Future<void> savePosition(String position) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(positionKey, position);
  }
  
  // Get saved position or return default if not set
  static Future<String> getPosition() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(positionKey) ?? 'Faculty Member';
  }
}