import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../app/constants/app_constants.dart';
import '../../data/services/local_storage_service.dart';

enum MPINMode { create, confirm, login, changeOld, changeNew, changeConfirm, reset }

class MPINController extends GetxController {
  final LocalStorageService _storage = Get.find<LocalStorageService>();

  final Rx<MPINMode> currentMode = MPINMode.create.obs;
  final RxString enteredMPIN = ''.obs;
  final RxString firstMPIN = ''.obs;
  final RxString currentMpinArg = ''.obs;
  final RxBool showError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isSubmitting = false.obs;

  final int mpinLength = AppConstants.mpinLength;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final mode = args['mode'] as String? ?? 'create';
    if (mode == 'login') {
      currentMode.value = MPINMode.login;
    } else if (mode == 'change') {
      currentMode.value = MPINMode.changeOld;
    } else if (mode == 'reset') {
      currentMode.value = MPINMode.create;
    } else {
      currentMode.value = MPINMode.create;
    }
  }

  String get titleText {
    switch (currentMode.value) {
      case MPINMode.create:
        return 'Create MPIN';
      case MPINMode.confirm:
        return 'Confirm MPIN';
      case MPINMode.login:
        return 'Welcome Back';
      case MPINMode.changeOld:
        return 'Enter Current MPIN';
      case MPINMode.changeNew:
        return 'Create New MPIN';
      case MPINMode.changeConfirm:
        return 'Confirm New MPIN';
      case MPINMode.reset:
        return 'Create MPIN';
    }
  }

  String get subtitleText {
    switch (currentMode.value) {
      case MPINMode.create:
        return 'Set a secure ${mpinLength}-digit MPIN for your account';
      case MPINMode.confirm:
        return 'Re-enter your MPIN to confirm';
      case MPINMode.login:
        return 'Enter your ${mpinLength}-digit MPIN to continue';
      case MPINMode.changeOld:
        return 'Enter your current MPIN';
      case MPINMode.changeNew:
        return 'Set a new ${mpinLength}-digit MPIN';
      case MPINMode.changeConfirm:
        return 'Re-enter your new MPIN to confirm';
      case MPINMode.reset:
        return 'Set a new ${mpinLength}-digit MPIN';
    }
  }

  String get headerText {
    switch (currentMode.value) {
      case MPINMode.create:
      case MPINMode.reset:
        return AppConstants.appName;
      case MPINMode.confirm:
        return 'Confirm';
      case MPINMode.login:
        return 'Welcome';
      case MPINMode.changeOld:
      case MPINMode.changeNew:
      case MPINMode.changeConfirm:
        return 'Change MPIN';
    }
  }

  void onKeypadTap(String value) {
    showError.value = false;
    errorMessage.value = '';
    if (value == 'delete') {
      if (enteredMPIN.value.isNotEmpty) {
        enteredMPIN.value = enteredMPIN.value.substring(0, enteredMPIN.value.length - 1);
      }
      return;
    }
    if (enteredMPIN.value.length < mpinLength) {
      enteredMPIN.value += value;
      if (enteredMPIN.value.length == mpinLength) {
        Future.delayed(const Duration(milliseconds: 150), _handleComplete);
      }
    }
  }

  void _handleComplete() async {
    isSubmitting.value = true;
    try {
      switch (currentMode.value) {
        case MPINMode.create:
        case MPINMode.reset:
          firstMPIN.value = enteredMPIN.value;
          enteredMPIN.value = '';
          currentMode.value = MPINMode.confirm;
          break;
        case MPINMode.confirm:
          if (enteredMPIN.value == firstMPIN.value) {
            await _storage.saveMPIN(firstMPIN.value);
            Get.snackbar('Success', 'MPIN created successfully');
            Get.offAllNamed(AppRoutes.dashboard);
          } else {
            _showError('MPIN does not match. Please try again.');
            enteredMPIN.value = '';
            firstMPIN.value = '';
            currentMode.value = MPINMode.create;
          }
          break;
        case MPINMode.login:
          final saved = _storage.getMPIN();
          if (saved != null && saved == enteredMPIN.value) {
            Get.offAllNamed(AppRoutes.dashboard);
          } else {
            _showError('Incorrect MPIN. Please try again.');
            enteredMPIN.value = '';
          }
          break;
        case MPINMode.changeOld:
          final saved = _storage.getMPIN();
          if (saved != null && saved == enteredMPIN.value) {
            currentMpinArg.value = enteredMPIN.value;
            enteredMPIN.value = '';
            currentMode.value = MPINMode.changeNew;
          } else {
            _showError('Current MPIN is incorrect.');
            enteredMPIN.value = '';
          }
          break;
        case MPINMode.changeNew:
          firstMPIN.value = enteredMPIN.value;
          enteredMPIN.value = '';
          currentMode.value = MPINMode.changeConfirm;
          break;
        case MPINMode.changeConfirm:
          if (enteredMPIN.value == firstMPIN.value) {
            await _storage.saveMPIN(firstMPIN.value);
            Get.snackbar('Success', 'MPIN changed successfully');
            Get.back();
          } else {
            _showError('New MPIN does not match. Please try again.');
            enteredMPIN.value = '';
            firstMPIN.value = '';
            currentMode.value = MPINMode.changeNew;
          }
          break;
      }
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      isSubmitting.value = false;
    }
  }

  void _showError(String msg) {
    errorMessage.value = msg;
    showError.value = true;
  }

  Future<bool> resetMPIN() async {
    try {
      await _storage.clearMPIN();
      return true;
    } catch (e) {
      return false;
    }
  }
}
