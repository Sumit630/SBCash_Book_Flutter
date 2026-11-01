import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/constants/app_constants.dart';
import '../../app/theme/app_colors.dart';
import '../../data/models/user_model.dart';
import '../users/users_controller.dart';

class WithdrawalController extends GetxController {
  final UsersController _usersController = Get.find<UsersController>();
  UsersController get usersC => _usersController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final RxString selectedUserId = ''.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<TimeOfDay> selectedTime =
      TimeOfDay.fromDateTime(DateTime.now()).obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    final uid = args?['userId'] as String?;
    if (uid != null) {
      selectedUserId.value = uid;
    }
  }

  UserModel? get selectedUser => _usersController.findUserById(selectedUserId.value);

  String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) return 'Amount is required';
    final n = double.tryParse(value);
    if (n == null) return 'Enter a valid amount';
    if (n <= 0) return 'Amount must be greater than 0';
    return null;
  }

  DateTime getCombinedDateTime() {
    final d = selectedDate.value;
    final t = selectedTime.value;
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.withdrawal),
        ),
        child: child!,
      ),
    );
    if (picked != null) selectedDate.value = picked;
  }

  Future<void> pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.withdrawal),
        ),
        child: child!,
      ),
    );
    if (picked != null) selectedTime.value = picked;
  }

  Future<bool> saveWithdrawal() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;
    if (selectedUserId.value.isEmpty) {
      Get.snackbar(
        'Select Customer',
        'Please select a customer for this withdrawal',
        backgroundColor: AppColors.warning,
        colorText: Colors.white,
      );
      return false;
    }
    isSubmitting.value = true;
    try {
      final amount = double.parse(amountController.text.trim());
      final note = noteController.text.trim();
      final dt = getCombinedDateTime();
      final ok = await _usersController.addTransaction(
        userId: selectedUserId.value,
        type: AppConstants.transactionTypeWithdrawal,
        amount: amount,
        dateTime: dt,
        note: note.isEmpty ? null : note,
      );
      if (ok) {
        Get.snackbar(
          'Withdrawal Added',
          '${AppConstants.rupeeSymbol}${amount.toStringAsFixed(0)} recorded as withdrawal',
          backgroundColor: AppColors.withdrawal,
          colorText: Colors.white,
        );
        _reset();
        return true;
      } else {
        Get.snackbar('Error', 'Failed to save withdrawal');
        return false;
      }
    } catch (_) {
      Get.snackbar('Error', 'Failed to save withdrawal');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  void _reset() {
    amountController.clear();
    noteController.clear();
  }
}
