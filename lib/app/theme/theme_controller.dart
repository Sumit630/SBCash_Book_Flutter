import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/local_storage_service.dart';

/// App-wide theme state.
///
/// Holds whether Dark Mode is enabled and persists the choice through the
/// project's existing [LocalStorageService] (SharedPreferences). Registered
/// as a permanent GetX service in `main.dart` so the whole app can react to
/// theme changes immediately.
class ThemeController extends GetxController {
  final LocalStorageService _storage = Get.find<LocalStorageService>();

  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _storage.isDarkMode();
  }

  ThemeMode get themeMode =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  Future<void> setDarkMode(bool value) async {
    if (isDarkMode.value == value) return;
    isDarkMode.value = value;
    await _storage.saveThemeMode(value);
  }

  Future<void> toggleDarkMode() => setDarkMode(!isDarkMode.value);
}
