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
  String get totalDeposit => _formatCurrency(_usersController.totalDepositAll);
  String get totalWithdrawal => _formatNumber(_usersController.totalWithdrawalAll);
  String get netBalance => _formatCurrency(_usersController.netBalance);

  /// Indian digit grouping via the `en_IN` locale (e.g. 1,25,000).
  /// The ₹ symbol is added by the summary card, so it is omitted here.
  static final NumberFormat _indianNumberFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '',
    decimalDigits: 0,
  );

  String _formatCurrency(double val) => _indianNumberFormat.format(val).trim();

  String _formatNumber(double val) {
    if (val >= 10000000) return '${(val / 10000000).toStringAsFixed(1)}Cr';
    if (val >= 100000) return '${(val / 100000).toStringAsFixed(1)}L';
    return val.toStringAsFixed(0);
  }

  void goToUsers() => Get.toNamed(AppRoutes.users);
  void goToTransactions() => Get.toNamed(AppRoutes.transactions);
  void goToSettings() => Get.toNamed(AppRoutes.settings);
  void goToAnalytics() => Get.toNamed(AppRoutes.analytics);
  void goToDeposit() => Get.toNamed(AppRoutes.deposit);
  void goToWithdrawal() => Get.toNamed(AppRoutes.withdrawal);
}
