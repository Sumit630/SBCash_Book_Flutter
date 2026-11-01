import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/routes/app_routes.dart';
import '../users/users_controller.dart';

class DashboardController extends GetxController {
  final UsersController _usersController = Get.find<UsersController>();

  UsersController get usersC => _usersController;

  String get todayDateStr {
    return DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now());
  }

  String get totalUsers => _usersController.users.length.toString();
  String get totalDeposit => _formatNumber(_usersController.totalDepositAll);
  String get totalWithdrawal => _formatNumber(_usersController.totalWithdrawalAll);
  String get netBalance => _formatNumber(_usersController.netBalance);

  String _formatNumber(double val) {
    if (val >= 10000000) return '${(val / 10000000).toStringAsFixed(1)}Cr';
    if (val >= 100000) return '${(val / 100000).toStringAsFixed(1)}L';
    return val.toStringAsFixed(0);
  }

  void goToUsers() => Get.toNamed(AppRoutes.users);
  void goToTransactions() => Get.toNamed(AppRoutes.transactions);
  void goToSettings() => Get.toNamed(AppRoutes.settings);
  void goToDeposit() => Get.toNamed(AppRoutes.deposit);
  void goToWithdrawal() => Get.toNamed(AppRoutes.withdrawal);
}
