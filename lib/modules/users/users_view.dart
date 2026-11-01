import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/user_card.dart';
import 'users_controller.dart';

class UsersView extends GetView<UsersController> {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.scaffold,
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            onPressed: () {
              controller.openAddUser();
              _showUserDialog(context);
            },
            icon: const Icon(Icons.person_add_alt_1_outlined),
            tooltip: 'Add Customer',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary));
                }
                final list = controller.filteredUsers;
                if (list.isEmpty) {
                  return EmptyState(
                    icon: Icons.people_outline,
                    title: 'No Customers Yet',
                    subtitle: 'Add your first customer to start recording transactions.',
                    action: CustomButton(
                      text: 'Add Customer',
                      icon: Icons.person_add_alt_1_outlined,
                      width: 220,
                      onPressed: () {
                        controller.openAddUser();
                        _showUserDialog(context);
                      },
                    ),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: controller.loadData,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, idx) {
                      final user = list[idx];
                      return UserCard(
                        user: user,
                        totalDeposit: controller.getUserTotalDeposit(user.id),
                        totalWithdrawal: controller.getUserTotalWithdrawal(user.id),
                        balance: controller.getUserBalance(user.id),
                        onTap: () => controller.goToUserDetails(user),
                        onEdit: () {
                          controller.openEditUser(user);
                          _showUserDialog(context);
                        },
                        onDelete: () async {
                          final ok = await controller.deleteUser(user.id);
                          if (ok) {
                            Get.snackbar('Deleted', 'Customer removed successfully');
                          }
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(() => controller.users.isEmpty
          ? const SizedBox.shrink()
          : FloatingActionButton(
              heroTag: 'users_fab',
              onPressed: () {
                controller.openAddUser();
                _showUserDialog(context);
              },
              child: const Icon(Icons.person_add),
            )),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Obx(() => CustomTextField(
            hintText: 'Search by name, phone, or address...',
            prefixIcon: Icons.search,
            suffixIcon: controller.searchQuery.value.isEmpty
                ? null
                : Icons.clear,
            onSuffixTap: () {
              controller.searchQuery.value = '';
            },
            onChanged: (v) => controller.searchQuery.value = v,
            textInputAction: TextInputAction.search,
          )),
    );
  }

  void _showUserDialog(BuildContext context) {
    final colors = context.colors;
    Get.dialog(
      AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Obx(() => SizedBox(
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
                            child: const Icon(
                              Icons.person_outline,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.isEditing.value
                                      ? 'Edit Customer'
                                      : 'Add New Customer',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Enter customer details below',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.textSecondary.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => Get.back(),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Icon(Icons.close,
                                  size: 22, color: colors.textHint),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: controller.nameController,
                        labelText: 'Full Name *',
                        prefixIcon: Icons.badge_outlined,
                        validator: controller.validateName,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        controller: controller.phoneController,
                        labelText: 'Mobile Number (Optional)',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        controller: controller.addressController,
                        labelText: 'Address (Optional)',
                        prefixIcon: Icons.location_on_outlined,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        controller: controller.initialBalanceController,
                        labelText: 'Initial Balance (Optional)',
                        prefixIcon: Icons.account_balance_wallet_outlined,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        validator: controller.validateOptionalNumber,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Cancel',
                              isOutlined: true,
                              onPressed: () => Get.back(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(() => CustomButton(
                                  text: controller.isEditing.value ? 'Update' : 'Add Customer',
                                  isLoading: false,
                                  onPressed: () async {
                                    final ok = await controller.saveUser();
                                    if (ok) {
                                      Get.back();
                                      Get.snackbar(
                                        controller.isEditing.value ? 'Updated' : 'Added',
                                        controller.isEditing.value
                                            ? 'Customer details updated'
                                            : 'Customer added successfully',
                                      );
                                    } else {
                                      Get.snackbar(
                                        'Error',
                                        'Failed to save customer. Please try again.',
                                        backgroundColor: AppColors.error,
                                        colorText: Colors.white,
                                      );
                                    }
                                  },
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
      barrierDismissible: false,
    );
  }
}
