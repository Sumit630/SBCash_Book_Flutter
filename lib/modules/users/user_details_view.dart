import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/constants/app_constants.dart';
import '../../data/models/user_model.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/summary_card.dart';
import '../../widgets/transaction_card.dart';
import 'users_controller.dart';

class UserDetailsView extends StatelessWidget {
  const UserDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UsersController>();
    final args = Get.arguments as Map<String, dynamic>?;
    final userId = args?['userId'] as String? ?? '';
    final user = controller.findUserById(userId);

    return Obx(() {
      final user = controller.findUserById(userId);
      if (user == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Customer Details')),
          body: const EmptyState(
            icon: Icons.person_off_outlined,
            title: 'Customer Not Found',
            subtitle: 'This customer may have been deleted.',
          ),
        );
      }

      return Scaffold(
        backgroundColor: context.colors.scaffold,
        body: _UserDetailsBody(user: user, controller: controller),
      );
    });
  }
}

class _UserDetailsBody extends StatelessWidget {
  final UserModel user;
  final UsersController controller;

  const _UserDetailsBody({required this.user, required this.controller});

  @override
  Widget build(BuildContext context) {
    final initials = user.name.isNotEmpty
        ? user.name
            .split(' ')
            .map((e) => e.isEmpty ? '' : e[0])
            .take(2)
            .join()
            .toUpperCase()
        : '?';

    final colors = context.colors;

    return Obx(() {
      final deposit = controller.getUserTotalDeposit(user.id);
      final withdrawal = controller.getUserTotalWithdrawal(user.id);
      final balance = controller.getUserBalance(user.id);
      final txns = controller.getUserTransactions(user.id);

      return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 170,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: AppColors.textWhite.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: AppColors.textWhite.withOpacity(0.25)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            initials,
                            style: const TextStyle(
                              color: AppColors.textWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (user.phone != null &&
                                  user.phone!.isNotEmpty) ...[
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      size: 12,
                                      color: Color(0xFFBBDEFB),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      user.phone!,
                                      style: const TextStyle(
                                        color: Color(0xFFBBDEFB),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              if (user.address != null &&
                                  user.address!.isNotEmpty) ...[
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 12,
                                      color: Color(0xFFBBDEFB),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        user.address!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xFFBBDEFB),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.textWhite.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Current Balance',
                            style: TextStyle(
                              color: AppColors.textWhite.withOpacity(0.9),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            NumberFormat.currency(
                                    locale: 'en_IN',
                                    symbol: AppConstants.rupeeSymbol,
                                    decimalDigits: 0)
                                .format(balance),
                            style: TextStyle(
                              color: balance >= 0
                                  ? const Color(0xFFC8E6C9)
                                  : const Color(0xFFFFCDD2),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            automaticallyImplyLeading: true,
            actions: [
              Obx(() => controller.isGeneratingPdf.value
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    )
                  : IconButton(
                      onPressed: () => controller.exportUserStatement(user.id),
                      icon: const Icon(Icons.picture_as_pdf_outlined),
                      tooltip: 'Export Statement',
                    )),
              IconButton(
                onPressed: () {
                  controller.openEditUser(user);
                  showDialog(
                    context: context,
                    builder: (_) => const _UserEditDialogWrap(),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit Customer',
              ),
            ],
          ),
        ],
        body: Container(
          decoration: BoxDecoration(
            color: colors.scaffold,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SummaryCard(
                              type: SummaryCardType.deposit,
                              value: deposit.toStringAsFixed(0),
                              label: 'Total Deposit',
                              icon: Icons.arrow_downward_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SummaryCard(
                              type: SummaryCardType.withdrawal,
                              value: withdrawal.toStringAsFixed(0),
                              label: 'Total Withdrawal',
                              icon: Icons.arrow_upward_outlined,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionChip(
                              'Add Deposit',
                              Icons.arrow_downward,
                              colors.depositBg,
                              colors.deposit,
                              () => Get.toNamed(AppRoutes.deposit,
                                  arguments: {'userId': user.id}),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionChip(
                              'Add Withdrawal',
                              Icons.arrow_upward,
                              colors.withdrawalBg,
                              colors.withdrawal,
                              () => Get.toNamed(AppRoutes.withdrawal,
                                  arguments: {'userId': user.id}),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Transaction History',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (txns.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: EmptyState(
                            icon: Icons.receipt_long_outlined,
                            title: 'No Transactions',
                            subtitle:
                                'Record deposits and withdrawals for this customer to see their history here.',
                            iconSize: 56,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        )
                      else
                        ...txns
                            .map((txn) => TransactionCard(
                                  transaction: txn,
                                  userName: user.name,
                                  showUser: false,
                                  onTap: () async {
                                    final ok =
                                        await controller.deleteTransaction(txn.id);
                                    if (ok) {
                                      Get.snackbar(
                                          'Deleted', 'Transaction removed');
                                    }
                                  },
                                ))
                            .toList(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildActionChip(
    String label,
    IconData icon,
    Color bg,
    Color fg,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: fg.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: fg, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: fg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserEditDialogWrap extends StatelessWidget {
  const _UserEditDialogWrap();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UsersController>();
    final colors = context.colors;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: controller.userFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: colors.balanceBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.edit_outlined, color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Edit Customer',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Update customer information',
                                style: TextStyle(fontSize: 12, color: colors.textHint),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(Icons.close, size: 22, color: colors.textHint),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _TextField(
                      controller: controller.nameController,
                      label: 'Full Name *',
                      icon: Icons.badge_outlined,
                      validator: controller.validateName,
                      capital: TextCapitalization.words,
                    ),
                    const SizedBox(height: 14),
                    _TextField(
                      controller: controller.phoneController,
                      label: 'Mobile (Optional)',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 14),
                    _TextField(
                      controller: controller.addressController,
                      label: 'Address (Optional)',
                      icon: Icons.location_on_outlined,
                      maxLines: 2,
                      capital: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 14),
                    _TextField(
                      controller: controller.initialBalanceController,
                      label: 'Initial Balance (Optional)',
                      icon: Icons.account_balance_wallet_outlined,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: controller.validateOptionalNumber,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colors.textSecondary,
                              side: BorderSide(color: colors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final ok = await controller.saveUser();
                              if (ok) {
                                Navigator.pop(context);
                                Get.snackbar('Updated', 'Customer details updated');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Update',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;
  final TextCapitalization capital;

  const _TextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.capital = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textCapitalization: capital,
      style: TextStyle(fontSize: 15, color: colors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: colors.card,
        prefixIcon: Icon(icon, color: colors.textSecondary, size: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
