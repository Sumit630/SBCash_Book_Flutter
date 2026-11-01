import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'app/theme/theme_controller.dart';
import 'app/constants/app_constants.dart';
import 'data/services/local_storage_service.dart';
import 'modules/users/users_controller.dart';
import 'modules/mpin/mpin_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(const MyApp());
}

Future<void> initServices() async {
  await Get.putAsync<LocalStorageService>(
    () async => LocalStorageService().init(),
    permanent: true,
  );
  Get.put<ThemeController>(ThemeController(), permanent: true);
  Get.lazyPut<UsersController>(() => UsersController(), fenix: true);
  Get.lazyPut<MPINController>(() => MPINController(), fenix: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeC = Get.find<ThemeController>();
    return Obx(
      () => GetMaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeC.themeMode,
        getPages: AppPages.pages,
        initialRoute: AppRoutes.splash,
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 300),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(
                MediaQuery.of(context).textScaler.scale(1).clamp(0.85, 1.3),
              ),
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
