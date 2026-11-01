import 'package:get/get.dart';
import '../../app/constants/app_constants.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/user_model.dart';
import '../users/users_controller.dart';

class TransactionsController extends GetxController {
  final UsersController _usersController = Get.find<UsersController>();
  UsersController get usersC => _usersController;

  final RxString filterType = AppConstants.filterAll.obs;
  final RxString selectedUserId = AppConstants.filterAll.obs;
  final RxString searchQuery = ''.obs;

  List<TransactionModel> get allTransactions {
    final list = _usersController.transactions.toList();
    list.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return list;
  }

  List<UserModel> get usersList => _usersController.users.toList();

  List<TransactionModel> get filteredTransactions {
    var list = allTransactions;

    if (filterType.value != AppConstants.filterAll) {
      list = list
          .where((t) =>
              t.type == filterType.value)
          .toList();
    }

    if (selectedUserId.value != AppConstants.filterAll) {
      list = list.where((t) => t.userId == selectedUserId.value).toList();
    }

    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((t) {
        final userName = t.getUserName(usersList)?.toLowerCase() ?? '';
        final note = t.note?.toLowerCase() ?? '';
        final amount = t.amount.toString();
        final typeStr = t.type.toLowerCase();
        return userName.contains(query) ||
            note.contains(query) ||
            amount.contains(query) ||
            typeStr.contains(query);
      }).toList();
    }

    return list;
  }

  double get filteredTotalDeposit {
    return filteredTransactions
        .where((t) => t.isDeposit)
        .fold(0.0, (s, t) => s + t.amount);
  }

  double get filteredTotalWithdrawal {
    return filteredTransactions
        .where((t) => t.isWithdrawal)
        .fold(0.0, (s, t) => s + t.amount);
  }

  void clearFilters() {
    filterType.value = AppConstants.filterAll;
    selectedUserId.value = AppConstants.filterAll;
    searchQuery.value = '';
  }
}
