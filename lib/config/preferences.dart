import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsOrderPreferences {
  static const smallListKey = "small_list_order_key";
  static const largeListKey = "large_list_order_key";

  // Default values
  final List<int> defaultSmallList = [0, 1];  // Example default list
  final List<int> defaultLargeList = [0, 1, 2, 3];  // Example default list
  // Save a small list of integers to SharedPreferences
  Future<void> setSmallList(List<int> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(value);
    await prefs.setString(smallListKey, encodedData);
  }

  // Retrieve a small list of integers from SharedPreferences, or use default if none exists
  Future<List<int>> getSmallList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(smallListKey);
    // await prefs.clear();

    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      return decodedData.cast<int>();
    } else {
      // Save default list if none exists
      await setSmallList(defaultSmallList);
      return defaultSmallList;
    }
  }

  Future<void> setDefaultStatisticsPrefs() async {
    await setSmallList(defaultSmallList);
    await setLargeList(defaultLargeList);
  }

  // Save a large list of integers to SharedPreferences
  Future<void> setLargeList(List<int> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(value);
    await prefs.setString(largeListKey, encodedData);
  }

  // Retrieve a large list of integers from SharedPreferences, or use default if none exists
  Future<List<int>> getLargeList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(largeListKey);

    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      return decodedData.cast<int>();
    } else {
      // Save default list if none exists
      await setLargeList(defaultLargeList);
      return defaultLargeList;
    }
  }
}
