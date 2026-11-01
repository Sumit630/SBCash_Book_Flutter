import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/constants/app_constants.dart';
import '../../app/routes/app_routes.dart';
import '../../data/models/user_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/services/local_storage_service.dart';
import '../../widgets/confirmation_dialog.dart';

class UsersController extends GetxController {
  final LocalStorageService _storage = Get.find<LocalStorageService>();

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString searchQuery = ''.obs;

  final GlobalKey<FormState> userFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController initialBalanceController = TextEditingController();
  final RxBool isEditing = false.obs;
  final RxString editingUserId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      users.value = _storage.getUsers();
      transactions.value = _storage.getTransactions();
      users.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      transactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    } catch (_) {
      users.value = [];
      transactions.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveAll() async {
    await _storage.saveUsers(users.toList());
    await _storage.saveTransactions(transactions.toList());
  }

  List<UserModel> get filteredUsers {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return users.toList();
    return users
        .where((u) =>
            u.name.toLowerCase().contains(query) ||
            (u.phone?.toLowerCase().contains(query) ?? false) ||
            (u.address?.toLowerCase().contains(query) ?? false))
        .toList();
  }

  UserModel? findUserById(String? id) {
    if (id == null) return null;
    try {
      return users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  List<TransactionModel> getUserTransactions(String userId) {
    return transactions.where((t) => t.userId == userId).toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  double getUserTotalDeposit(String userId) {
    return getUserTransactions(userId)
        .where((t) => t.isDeposit)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getUserTotalWithdrawal(String userId) {
    return getUserTransactions(userId)
        .where((t) => t.isWithdrawal)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getUserBalance(String userId) {
    final user = findUserById(userId);
    final initial = user?.initialBalance ?? 0.0;
    return initial + getUserTotalDeposit(userId) - getUserTotalWithdrawal(userId);
  }

  double get totalUsersBalance {
    return users.fold(0.0, (sum, u) => sum + getUserBalance(u.id));
  }

  double get totalDepositAll {
    final userInitial = users.fold(0.0, (sum, u) => sum + (u.initialBalance ?? 0.0));
    final deposits = transactions.where((t) => t.isDeposit).fold(0.0, (sum, t) => sum + t.amount);
    return userInitial + deposits;
  }

  double get totalWithdrawalAll {
    return transactions.where((t) => t.isWithdrawal).fold(0.0, (sum, t) => sum + t.amount);
  }

  double get netBalance => totalDepositAll - totalWithdrawalAll;

  List<TransactionModel> get recentTransactions {
    final sorted = transactions.toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return sorted.take(AppConstants.recentTransactionLimit).toList();
  }

  void openAddUser() {
    isEditing.value = false;
    editingUserId.value = '';
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    initialBalanceController.clear();
  }

  void openEditUser(UserModel user) {
    isEditing.value = true;
    editingUserId.value = user.id;
    nameController.text = user.name;
    phoneController.text = user.phone ?? '';
    addressController.text = user.address ?? '';
    initialBalanceController.text =
        user.initialBalance != null && user.initialBalance! > 0
            ? user.initialBalance!.toStringAsFixed(0)
            : '';
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateOptionalNumber(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final n = double.tryParse(value);
    if (n == null) return 'Enter a valid number';
    if (n < 0) return 'Cannot be negative';
    return null;
  }

  Future<bool> saveUser() async {
    if (!(userFormKey.currentState?.validate() ?? false)) return false;

    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();
    final initialStr = initialBalanceController.text.trim();
    final initialBalance = initialStr.isEmpty ? null : (double.tryParse(initialStr) ?? 0.0);

    try {
      if (isEditing.value) {
        final existing = findUserById(editingUserId.value);
        if (existing == null) return false;
        final updated = existing.copyWith(
          name: name,
          phone: phone.isEmpty ? null : phone,
          address: address.isEmpty ? null : address,
          initialBalance: initialBalance,
        );
        final idx = users.indexWhere((u) => u.id == existing.id);
        if (idx != -1) {
          users[idx] = updated;
        }
      } else {
        final newUser = UserModel(
          id: 'u_${DateTime.now().millisecondsSinceEpoch}_${users.length}',
          name: name,
          phone: phone.isEmpty ? null : phone,
          address: address.isEmpty ? null : address,
          initialBalance: initialBalance,
          createdAt: DateTime.now(),
        );
        users.insert(0, newUser);
      }
      await _saveAll();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    final confirmed = await ConfirmationDialog.show(
      title: 'Delete Customer?',
      message:
          'This will permanently delete the customer and all their transaction history. This action cannot be undone.',
      confirmText: 'Delete',
      isDanger: true,
      icon: Icons.delete_forever,
    );
    if (!confirmed) return false;
    try {
      users.removeWhere((u) => u.id == userId);
      transactions.removeWhere((t) => t.userId == userId);
      await _saveAll();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> addTransaction({
    required String userId,
    required String type,
    required double amount,
    required DateTime dateTime,
    String? note,
  }) async {
    try {
      final newTxn = TransactionModel(
        id: 't_${DateTime.now().millisecondsSinceEpoch}_${transactions.length}',
        userId: userId,
        type: type,
        amount: amount,
        dateTime: dateTime,
        note: note,
      );
      transactions.insert(0, newTxn);
      await _saveAll();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteTransaction(String txnId) async {
    final confirmed = await ConfirmationDialog.show(
      title: 'Delete Transaction?',
      message: 'This transaction will be permanently deleted. Balance will be recalculated.',
      confirmText: 'Delete',
      isDanger: true,
    );
    if (!confirmed) return false;
    try {
      transactions.removeWhere((t) => t.id == txnId);
      await _saveAll();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> clearAllData() async {
    try {
      users.clear();
      transactions.clear();
      await _storage.clearAllData();
      return true;
    } catch (_) {
      return false;
    }
  }

  String formatAmount(double amount) {
    return NumberFormat.currency(locale: 'en_IN', symbol: AppConstants.rupeeSymbol, decimalDigits: 0)
        .format(amount);
  }

  String formatDate(DateTime dt) {
    return DateFormat('dd MMM yyyy').format(dt);
  }

  String formatDateTime(DateTime dt) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
  }

  String formatTime(DateTime dt) {
    return DateFormat('hh:mm a').format(dt);
  }

  void goToUserDetails(UserModel user) {
    Get.toNamed(AppRoutes.userDetails, arguments: {'userId': user.id});
  }
}
