import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/constants/app_constants.dart';
import '../../widgets/summary_card.dart';
import '../../widgets/transaction_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_title.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.scaffold,
      body: Stack(
        children: [
          SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 120,
                  collapsedHeight: 96,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppColors.primary,
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      final availableHeight = constraints.maxHeight;
                      final isCollapsing = availableHeight < 110;
                      final topPadding = isCollapsing
                          ? 14.0
                          : MediaQuery.of(context).padding.top + 16;
                      final bottomPadding = isCollapsing ? 12.0 : 16.0;
                      final dateSpacing = isCollapsing ? 4.0 : 6.0;
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.primary, AppColors.primaryDark],
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(
                          20,
                          topPadding,
                          20,
                          bottomPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Expanded(
                                  child: Text(
                                    AppConstants.appName,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textWhite,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: controller.goToSettings,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.textWhite.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.settings_outlined,
                                        color: AppColors.textWhite, size: 22),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: dateSpacing),
                            if (!isCollapsing || availableHeight >= 80)
                              Text(
                                controller.todayDateStr,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textWhite.withOpacity(0.85),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  automaticallyImplyLeading: false,
                  elevation: 0,
                ),
              ],
              body: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => controller.usersC.loadData(),
                child: Obx(() {
                  final usersC = controller.usersC;
                  if (usersC.isLoading.value) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  }
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Transform.translate(
                      offset: const Offset(0, -16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.colors.scaffold,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 30),
                            _buildSummaryCards(),
                            _buildQuickActions(context),
                            SectionTitle(
                              title: 'Recent Transactions',
                              action: TextButton(
                                onPressed: controller.goToTransactions,
                                child: const Text(
                                  'View All',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                            ),
                            _buildRecentTransactions(),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          _buildBottomBar(context),
          _buildFAB(context),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  type: SummaryCardType.users,
                  value: controller.totalUsers,
                  label: 'Total Customers',
                  icon: Icons.people_outline,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SummaryCard(
                  type: SummaryCardType.balance,
                  value: controller.netBalance,
                  label: 'Net Balance',
                  icon: Icons.account_balance_wallet_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  type: SummaryCardType.deposit,
                  value: controller.totalDeposit,
                  label: 'Total Deposit',
                  icon: Icons.arrow_downward_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SummaryCard(
                  type: SummaryCardType.withdrawal,
                  value: controller.totalWithdrawal,
                  label: 'Total Withdrawal',
                  icon: Icons.arrow_upward_outlined,
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: _buildActionTile(
              context,
              colors.depositBg,
              colors.deposit,
              Icons.add_circle_outline,
              'Add Deposit',
              controller.goToDeposit,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionTile(
              context,
              colors.withdrawalBg,
              colors.withdrawal,
              Icons.remove_circle_outline,
              'Add Withdrawal',
              controller.goToWithdrawal,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionTile(
              context,
              colors.balanceBg,
              colors.balance,
              Icons.people_alt_outlined,
              'Customers',
              controller.goToUsers,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
      BuildContext context,
      Color bgColor,
      Color fgColor,
      IconData icon,
      String label,
      VoidCallback onTap,
      ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: fgColor.withOpacity(0.15)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.colors.card,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: fgColor, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: fgColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Obx(() {
      final recent = controller.usersC.recentTransactions;
      if (recent.isEmpty) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'No Transactions Yet',
            subtitle: 'Start by adding your first deposit or withdrawal.',
            iconSize: 56,
            padding: const EdgeInsets.symmetric(vertical: 28),
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: recent
              .map((txn) {
            final userName = txn.getUserName(controller.usersC.users.toList()) ?? 'Unknown';
            return TransactionCard(
              transaction: txn,
              userName: userName,
              onTap: () {
                final user = controller.usersC.findUserById(txn.userId);
                if (user != null) {
                  Get.toNamed(AppRoutes.userDetails, arguments: {'userId': user.id});
                }
              },
            );
          })
              .toList(),
        ),
      );
    });
  }

  Widget _buildFAB(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    final double centerX = MediaQuery.of(context).size.width / 2;
    return Positioned(
      bottom: 50 + bottomInset,
      left: centerX - 28,
      child: Obx(() {
        final users = controller.usersC.users;
        return FloatingActionButton(
          heroTag: 'dashboard_add_fab',
          onPressed: users.isEmpty ? controller.goToUsers : () => _showAddOptions(context),
          backgroundColor: AppColors.primary,
          elevation: 8,
          shape: const CircleBorder(),
          tooltip: users.isEmpty ? 'Add Customer' : 'New Entry',
          child: const Icon(Icons.add, size: 30, color: AppColors.textWhite),
        );
      }),
    );
  }

  void _showAddOptions(BuildContext context) {
    final colors = context.colors;
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Quick Entry',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildSheetOption(
                      colors.depositBg,
                      colors.deposit,
                      Icons.arrow_downward_outlined,
                      'Deposit',
                          () {
                        Get.back();
                        controller.goToDeposit();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSheetOption(
                      colors.withdrawalBg,
                      colors.withdrawal,
                      Icons.arrow_upward_outlined,
                      'Withdrawal',
                          () {
                        Get.back();
                        controller.goToWithdrawal();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSheetOption(
                      colors.balanceBg,
                      colors.balance,
                      Icons.person_add_alt_outlined,
                      'Customer',
                          () {
                        Get.back();
                        controller.goToUsers();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: colors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildSheetOption(
      Color bg,
      Color fg,
      IconData icon,
      String label,
      VoidCallback onTap,
      ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: fg.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: fg, size: 32),
              const SizedBox(height: 8),
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

  Widget _buildBottomBar(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipPath(
        clipper: _BottomDipClipper(),
        child: Container(
          height: 80 + bottomInset,
          width: double.infinity,
          padding: EdgeInsets.only(bottom: bottomInset),
          decoration: BoxDecoration(
            color: context.colors.card,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                spreadRadius: 2,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Obx(() {
            final int count = controller.usersC.transactions.length;
            return Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(context, Icons.home_outlined, Icons.home,
                          'Home', true, () {}),
                      _buildNavItem(context, Icons.people_outline, Icons.people,
                          'Customers', false, controller.goToUsers),
                    ],
                  ),
                ),
                const SizedBox(width: 64), // reserved space for the centered FAB
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(context, Icons.history_outlined,
                          Icons.history, 'History', false,
                          controller.goToTransactions,
                          badge: count),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context,
      IconData icon,
      IconData activeIcon,
      String label,
      bool isActive,
      VoidCallback onTap, {
        int? badge,
      }) {
    final colors = context.colors;
    return InkWell(
      onTap: isActive ? null : onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? AppColors.primary : colors.textHint,
                  size: 24,
                ),
                if (badge != null && badge > 0)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge > 99 ? '99+' : '$badge',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.primary : colors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Curved dip clipper for the floating bottom navigation bar.
///
/// Cuts a smooth notch in the top-center of the bar so the circular
/// Add/New Entry FAB can sit inside the curve. Mirrors the reference
/// project's bottom navigation bar shape.
class _BottomDipClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(size.width * 0.25, 0);
    path.cubicTo(
      size.width * 0.375, 0,
      size.width * 0.375, 40,
      size.width * 0.5, 40,
    );
    path.cubicTo(
      size.width * 0.625, 40,
      size.width * 0.625, 0,
      size.width * 0.75, 0,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
