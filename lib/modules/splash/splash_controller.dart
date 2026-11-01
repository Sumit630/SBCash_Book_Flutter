import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../app/constants/app_constants.dart';
import '../../data/services/local_storage_service.dart';

class SplashController extends GetxController {
  final LocalStorageService _storage = Get.find<LocalStorageService>();

  final RxBool isLoading = true.obs;

  @override
  void onReady() {
    super.onReady();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(AppConstants.splashDuration);
    isLoading.value = false;
    _navigate();
  }

  void _navigate() {
    final hasMPIN = _storage.hasMPIN();
    if (hasMPIN) {
      Get.offAllNamed(AppRoutes.mpin, arguments: {'mode': 'login'});
    } else {
      Get.offAllNamed(AppRoutes.mpin, arguments: {'mode': 'create'});
    }
  }
}
