import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../app/constants/app_constants.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/theme_controller.dart';
import '../../widgets/confirmation_dialog.dart';
import '../users/users_controller.dart';
import '../mpin/mpin_controller.dart';

class SettingsController extends GetxController {
  final UsersController _usersController = Get.find<UsersController>();
  final ThemeController _themeController = Get.find<ThemeController>();

  final RxString appVersion = AppConstants.appVersion.obs;

  RxBool get isDarkMode => _themeController.isDarkMode;

  Future<void> setDarkMode(bool value) => _themeController.setDarkMode(value);

  Future<void> goToChangeMPIN() async {
    Get.toNamed(AppRoutes.mpin, arguments: {'mode': 'change'});
  }

  Future<bool> resetMPIN() async {
    final confirmed = await ConfirmationDialog.show(
      title: 'Reset MPIN?',
      message:
          'This will clear your current MPIN. On next app launch, you will be asked to create a new MPIN.\n\nYour accounting data (customers and transactions) will NOT be affected.',
      confirmText: 'Reset MPIN',
      isDanger: true,
      icon: Icons.lock_reset,
    );
    if (!confirmed) return false;
    final c = Get.find<MPINController>();
    final ok = await c.resetMPIN();
    if (ok) {
      Get.snackbar(
        'MPIN Reset',
        'Next time you open the app, create a new MPIN.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return ok;
  }

  Future<bool> clearAllData() async {
    final step1 = await ConfirmationDialog.show(
      title: 'Clear All Data?',
      message:
          'This action is IRREVERSIBLE.\n\nAll customers, their accounts, and complete transaction history will be PERMANENTLY DELETED.\n\nThis cannot be undone.',
      confirmText: 'Yes, Delete Everything',
      isDanger: true,
      icon: Icons.delete_forever,
    );
    if (!step1) return false;

    final step2 = await ConfirmationDialog.show(
      title: 'Confirm Final Deletion',
      message:
          'Are you absolutely SURE?\n\nAll customers, transactions, and accounting data will be completely erased.\n\nThis action cannot be undone.',
      confirmText: 'I Understand, Delete',
      isDanger: true,
      icon: Icons.warning_amber_rounded,
    );
    if (!step2) return false;

    try {
      await _usersController.clearAllData();
      Get.snackbar(
        'All Data Cleared',
        'All customers and transactions have been permanently deleted.',
        backgroundColor: AppColors.error,
        colorText: AppColors.textWhite,
        snackPosition: SnackPosition.BOTTOM,
        duration: AppConstants.snackbarDuration,
      );
      return true;
    } catch (_) {
      Get.snackbar('Error', 'Failed to clear data');
      return false;
    }
  }

  String get totalCustomers => _usersController.users.length.toString();
  String get totalTransactions => _usersController.transactions.length.toString();

  String get totalDeposit {
    final amount = _usersController.users.fold<double>(0.0, (sum, u) {
      return sum + _usersController.getUserTotalDeposit(u.id);
    });
    return amount.toStringAsFixed(0);
  }

  String get totalWithdrawal {
    final amount = _usersController.users.fold<double>(0.0, (sum, u) {
      return sum + _usersController.getUserTotalWithdrawal(u.id);
    });
    return amount.toStringAsFixed(0);
  }

  Future<void> logOut() async {
    final confirmed = await ConfirmationDialog.show(
      title: 'Lock App?',
      message: 'You will be returned to the MPIN screen.',
      confirmText: 'Lock',
      icon: Icons.lock_outline,
    );
    if (!confirmed) return;
    Get.offAllNamed(AppRoutes.mpin, arguments: {'mode': 'login'});
  }
}
