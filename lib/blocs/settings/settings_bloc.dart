import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsBloc {
  void loadPreferences() {}

  void saveWeight(String weight) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      double weightAsDouble = double.parse(weight);
      prefs.setDouble("weight", weightAsDouble);
    } catch (e) {
      prefs.setDouble("weight", 0.0);
    }
  }

  Future<double?> getSavedWeight() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("weight");
  }
}