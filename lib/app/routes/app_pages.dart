import 'package:get/get.dart';
import 'app_routes.dart';
import '../../modules/splash/splash_view.dart';
import '../../modules/splash/splash_controller.dart';
import '../../modules/mpin/mpin_view.dart';
import '../../modules/mpin/mpin_controller.dart';
import '../../modules/dashboard/dashboard_view.dart';
import '../../modules/dashboard/dashboard_controller.dart';
import '../../modules/users/users_view.dart';
import '../../modules/users/user_details_view.dart';
import '../../modules/users/users_controller.dart';
import '../../modules/deposit/deposit_view.dart';
import '../../modules/deposit/deposit_controller.dart';
import '../../modules/withdrawal/withdrawal_view.dart';
import '../../modules/withdrawal/withdrawal_controller.dart';
import '../../modules/transactions/transactions_view.dart';
import '../../modules/transactions/transactions_controller.dart';
import '../../modules/settings/settings_view.dart';
import '../../modules/settings/settings_controller.dart';
import '../../modules/analytics/analytics_view.dart';
import '../../modules/analytics/analytics_controller.dart';

class AppPages {
  AppPages._();

  static const String initial = AppRoutes.splash;

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder.put(() => SplashController()),
    ),
    GetPage(
      name: AppRoutes.mpin,
      page: () => const MPINView(),
      binding: BindingsBuilder.put(() => MPINController()),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: BindingsBuilder.put(() => DashboardController()),
    ),
    GetPage(
      name: AppRoutes.users,
      page: () => const UsersView(),
      binding: BindingsBuilder.put(() => UsersController()),
    ),
    GetPage(
      name: AppRoutes.userDetails,
      page: () => const UserDetailsView(),
    ),
    GetPage(
      name: AppRoutes.addUser,
      page: () => const UsersView(),
      binding: BindingsBuilder.put(() => UsersController()),
    ),
    GetPage(
      name: AppRoutes.editUser,
      page: () => const UsersView(),
      binding: BindingsBuilder.put(() => UsersController()),
    ),
    GetPage(
      name: AppRoutes.deposit,
      page: () => const DepositView(),
      binding: BindingsBuilder.put(() => DepositController()),
    ),
    GetPage(
      name: AppRoutes.withdrawal,
      page: () => const WithdrawalView(),
      binding: BindingsBuilder.put(() => WithdrawalController()),
    ),
    GetPage(
      name: AppRoutes.transactions,
      page: () => const TransactionsView(),
      binding: BindingsBuilder.put(() => TransactionsController()),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: BindingsBuilder.put(() => SettingsController()),
    ),
    GetPage(
      name: AppRoutes.analytics,
      page: () => const AnalyticsView(),
      binding: BindingsBuilder.put(() => AnalyticsController()),
    ),
  ];
}
