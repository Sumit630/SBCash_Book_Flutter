import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/constants/app_constants.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/transaction_card.dart';
import '../../widgets/summary_card.dart';
import 'transactions_controller.dart';

class TransactionsView extends GetView<TransactionsController> {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.scaffold,
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          Obx(() => controller.isGeneratingPdf.value
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
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
                  onPressed: controller.exportToPdf,
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  tooltip: 'Export PDF',
                )),
          Obx(() {
            final hasFilter = controller.filterType.value != AppConstants.filterAll ||
                controller.selectedUserId.value != AppConstants.filterAll ||
                controller.searchQuery.value.isNotEmpty;
            return hasFilter
                ? IconButton(
                    onPressed: controller.clearFilters,
                    icon: const Icon(Icons.filter_alt_off_outlined),
                    tooltip: 'Clear Filters',
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final users = controller.usersList;
          final txns = controller.filteredTransactions;

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildSearchBar(),
                    _buildFilterChips(context, users),
                    if (txns.isNotEmpty) _buildFilteredSummary(),
                  ],
                ),
              ),
            ],
            body: txns.isEmpty
                ? _buildEmptyState(users)
                : RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: controller.usersC.loadData,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemCount: txns.length,
                      itemBuilder: (context, idx) {
                        final txn = txns[idx];
                        final userName = txn.getUserName(users) ?? 'Unknown';
                        return TransactionCard(
                          transaction: txn,
                          userName: userName,
                          onTap: () async {
                            final user = controller.usersC.findUserById(txn.userId);
                            if (user != null) {
                              Get.toNamed(AppRoutes.userDetails,
                                  arguments: {'userId': user.id});
                            }
                          },
                        );
                      },
                    ),
                  ),
          );
        }),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Obx(() => CustomTextField(
            hintText: 'Search transactions...',
            prefixIcon: Icons.search,
            suffixIcon: controller.searchQuery.value.isEmpty
                ? null
                : Icons.clear,
            onSuffixTap: () => controller.searchQuery.value = '',
            onChanged: (v) => controller.searchQuery.value = v,
            textInputAction: TextInputAction.search,
          )),
    );
  }

  Widget _buildFilterChips(BuildContext context, List users) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 42,
            child: Obx(() {
              final type = controller.filterType.value;
              return ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildChip(
                    context,
                    label: 'All',
                    selected: type == AppConstants.filterAll,
                    onTap: () => controller.filterType.value = AppConstants.filterAll,
                  ),
                  const SizedBox(width: 8),
                  _buildChip(
                    context,
                    label: 'Deposits',
                    selected: type == AppConstants.transactionTypeDeposit,
                    selectedColor: colors.deposit,
                    onTap: () =>
                        controller.filterType.value = AppConstants.transactionTypeDeposit,
                  ),
                  const SizedBox(width: 8),
                  _buildChip(
                    context,
                    label: 'Withdrawals',
                    selected: type == AppConstants.transactionTypeWithdrawal,
                    selectedColor: colors.withdrawal,
                    onTap: () =>
                        controller.filterType.value = AppConstants.transactionTypeWithdrawal,
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 42,
            child: Obx(() {
              final sel = controller.selectedUserId.value;
              final children = <Widget>[
                _buildChip(
                  context,
                  label: 'All Customers',
                  selected: sel == AppConstants.filterAll,
                  onTap: () => controller.selectedUserId.value = AppConstants.filterAll,
                ),
              ];
              for (final u in users) {
                children.add(const SizedBox(width: 8));
                children.add(_buildChip(
                  context,
                  label: u.name,
                  selected: sel == u.id,
                  onTap: () => controller.selectedUserId.value = u.id,
                ));
              }
              return ListView(
                scrollDirection: Axis.horizontal,
                children: children,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
    Color? selectedColor,
  }) {
    final colors = context.colors;
    final color = selectedColor ?? AppColors.primary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.1) : colors.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? color.withOpacity(0.4) : colors.border,
              width: selected ? 1.3 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? color : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilteredSummary() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Obx(() {
        final d = controller.filteredTotalDeposit;
        final w = controller.filteredTotalWithdrawal;
        final net = d - w;
        return Row(
          children: [
            Expanded(
              child: SummaryCard(
                type: SummaryCardType.deposit,
                value: d.toStringAsFixed(0),
                label: 'Deposits',
                icon: Icons.arrow_downward,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SummaryCard(
                type: SummaryCardType.withdrawal,
                value: w.toStringAsFixed(0),
                label: 'Withdrawals',
                icon: Icons.arrow_upward,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SummaryCard(
                type: SummaryCardType.balance,
                value: net.toStringAsFixed(0),
                label: 'Net',
                icon: Icons.account_balance_wallet,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState(List users) {
    final hasAny = controller.allTransactions.isNotEmpty;
    return EmptyState(
      icon: Icons.receipt_long_outlined,
      title: hasAny ? 'No Matching Transactions' : 'No Transactions Yet',
      subtitle: hasAny
          ? 'Try adjusting your filters or search term.'
          : 'Start adding deposits and withdrawals to see them here.',
      action: hasAny
          ? null
          : Wrap(
              spacing: 10,
              alignment: WrapAlignment.center,
              children: [
                if (users.isEmpty)
                  ElevatedButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.users),
                    icon: const Icon(Icons.person_add, size: 18),
                    label: const Text('Add Customer'),
                  ),
                if (users.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.deposit),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deposit,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.arrow_downward, size: 18),
                    label: const Text('Add Deposit'),
                  ),
                if (users.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.withdrawal),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.withdrawal,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.arrow_upward, size: 18),
                    label: const Text('Add Withdrawal'),
                  ),
              ],
            ),
    );
  }
}
