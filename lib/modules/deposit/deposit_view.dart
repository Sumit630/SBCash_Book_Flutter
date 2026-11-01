import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/constants/app_constants.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'deposit_controller.dart';

class DepositView extends GetView<DepositController> {
  const DepositView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.scaffold,
      appBar: AppBar(
        title: const Text('Add Deposit'),
        backgroundColor: AppColors.deposit,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: Obx(() {
              final users = controller.usersC.users.toList();
              if (users.isEmpty) {
                return _EmptyUserCard(
                  title: 'No Customers Available',
                  subtitle: 'Add a customer first before recording a deposit.',
                  color: AppColors.deposit,
                  onTap: () => Get.toNamed(AppRoutes.users),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  _buildUserDropdown(context, users),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: controller.amountController,
                    labelText: 'Amount (${AppConstants.rupeeSymbol}) *',
                    prefixIcon: Icons.currency_rupee,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    validator: controller.validateAmount,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateField(context),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTimeField(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: controller.noteController,
                    labelText: 'Note / Description (Optional)',
                    prefixIcon: Icons.edit_note_outlined,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 28),
                  Obx(() {
                    final user = controller.selectedUser;
                    if (user == null) return const SizedBox.shrink();
                    final dep = controller.usersC.getUserTotalDeposit(user.id);
                    final bal = controller.usersC.getUserBalance(user.id);
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.depositBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: colors.deposit.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: colors.card,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_outlined,
                              color: AppColors.deposit,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: colors.deposit,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Total Deposit: ${AppConstants.rupeeSymbol}${dep.toStringAsFixed(0)}   •   Balance: ${AppConstants.rupeeSymbol}${bal.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.deposit.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 28),
                  Obx(() => CustomButton(
                        text: 'Record Deposit',
                        icon: Icons.arrow_downward,
                        isLoading: controller.isSubmitting.value,
                        color: AppColors.deposit,
                        onPressed: () async {
                          final ok = await controller.saveDeposit();
                          if (ok) {
                            Future.delayed(const Duration(milliseconds: 500), () {
                              Get.back();
                            });
                          }
                        },
                      )),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Cancel',
                    isOutlined: true,
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.depositBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.deposit.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.deposit,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.arrow_downward, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Record Deposit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.deposit,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Add money to customer account',
                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserDropdown(BuildContext context, List users) {
    final colors = context.colors;
    return Obx(() {
      final selected = controller.selectedUser;
      return Container(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: controller.selectedUserId.value.isEmpty
                ? colors.border
                : colors.deposit.withOpacity(0.5),
            width: controller.selectedUserId.value.isEmpty ? 1 : 1.5,
          ),
        ),
        child: InkWell(
          onTap: () => _showUserSheet(context, users),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.person_outline,
                    color: colors.textSecondary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selected == null ? 'Select Customer *' : selected.name,
                        style: TextStyle(
                          fontSize: 15,
                          color: selected == null ? colors.textHint : colors.textPrimary,
                          fontWeight:
                              selected == null ? FontWeight.w400 : FontWeight.w600,
                        ),
                      ),
                      if (selected != null &&
                          selected.phone != null &&
                          selected.phone!.isNotEmpty)
                        Text(
                          selected.phone!,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textHint,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: colors.textSecondary),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showUserSheet(BuildContext context, List users) {
    final colors = context.colors;
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.6,
        ),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  children: [
                    Text(
                      'Select Customer',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, color: colors.textHint),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: colors.divider),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: users.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: colors.divider),
                  itemBuilder: (_, idx) {
                    final u = users[idx];
                    final initials = u.name.isNotEmpty
                        ? u.name
                            .split(' ')
                            .map((e) => e.isEmpty ? '' : e[0])
                            .take(2)
                            .join()
                            .toUpperCase()
                        : '?';
                    return Obx(() {
                      final selectedId = controller.selectedUserId.value;
                      return InkWell(
                        onTap: () {
                          controller.selectedUserId.value = u.id;
                          Get.back();
                        },
                        child: Container(
                          color: selectedId == u.id
                              ? colors.depositBg.withOpacity(0.5)
                              : null,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: colors.depositBg,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  initials,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: colors.deposit,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      u.name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: colors.textPrimary,
                                      ),
                                    ),
                                    if (u.phone != null && u.phone!.isNotEmpty)
                                      Text(
                                        u.phone!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: colors.textHint,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (selectedId == u.id)
                                Icon(Icons.check_circle,
                                    color: colors.deposit, size: 22),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Obx(() => CustomTextField(
          controller: TextEditingController(
            text: DateFormat('dd MMM yyyy').format(controller.selectedDate.value),
          ),
          labelText: 'Date',
          prefixIcon: Icons.calendar_today_outlined,
          readOnly: true,
          onTap: () => controller.pickDate(context),
          suffixIcon: Icons.arrow_drop_down,
        ));
  }

  Widget _buildTimeField(BuildContext context) {
    return Obx(() => CustomTextField(
          controller: TextEditingController(
            text: controller.selectedTime.value.format(context),
          ),
          labelText: 'Time',
          prefixIcon: Icons.access_time_outlined,
          readOnly: true,
          onTap: () => controller.pickTime(context),
          suffixIcon: Icons.arrow_drop_down,
        ));
  }
}

class _EmptyUserCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _EmptyUserCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.people_outline, color: color, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: colors.textSecondary),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Go to Customers',
            icon: Icons.people_alt_outlined,
            color: color,
            width: 240,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
