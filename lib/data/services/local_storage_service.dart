import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../app/constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';

class LocalStorageService extends GetxService {
  late final SharedPreferences _prefs;

  Future<LocalStorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> saveMPIN(String mpin) async {
    await _prefs.setString(AppConstants.storageKeyMpin, mpin);
    await _prefs.setBool(AppConstants.storageKeyMpinCreated, true);
  }

  String? getMPIN() {
    return _prefs.getString(AppConstants.storageKeyMpin);
  }

  Future<void> clearMPIN() async {
    await _prefs.remove(AppConstants.storageKeyMpin);
    await _prefs.setBool(AppConstants.storageKeyMpinCreated, false);
  }

  bool hasMPIN() {
    return _prefs.getBool(AppConstants.storageKeyMpinCreated) ?? false;
  }

  Future<void> saveThemeMode(bool isDark) async {
    await _prefs.setBool(AppConstants.storageKeyThemeMode, isDark);
  }

  bool isDarkMode() {
    return _prefs.getBool(AppConstants.storageKeyThemeMode) ?? false;
  }

  Future<void> saveUsers(List<UserModel> users) async {
    final List<Map<String, dynamic>> userMaps = users.map((u) => u.toMap()).toList();
    final String jsonString = jsonEncode(userMaps);
    await _prefs.setString(AppConstants.storageKeyUsers, jsonString);
  }

  List<UserModel> getUsers() {
    final String? jsonString = _prefs.getString(AppConstants.storageKeyUsers);
    if (jsonString == null || jsonString.isEmpty) return [];
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((m) => UserModel.fromMap(Map<String, dynamic>.from(m))).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    final List<Map<String, dynamic>> txnMaps = transactions.map((t) => t.toMap()).toList();
    final String jsonString = jsonEncode(txnMaps);
    await _prefs.setString(AppConstants.storageKeyTransactions, jsonString);
  }

  List<TransactionModel> getTransactions() {
    final String? jsonString = _prefs.getString(AppConstants.storageKeyTransactions);
    if (jsonString == null || jsonString.isEmpty) return [];
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((m) => TransactionModel.fromMap(Map<String, dynamic>.from(m))).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> clearAllData() async {
    await _prefs.remove(AppConstants.storageKeyUsers);
    await _prefs.remove(AppConstants.storageKeyTransactions);
  }

  Future<void> clearEverything() async {
    await _prefs.clear();
  }
}
