import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/constants/app_constants.dart';
import 'settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.scaffold,
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildDataSummaryCard(context),
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Appearance'),
              _buildDarkModeTile(context),
              const SizedBox(height: 20),
              _buildSectionTitle(context, 'Security'),
              _buildSettingsTile(
                context,
                icon: Icons.lock_outline,
                iconBg: colors.balanceBg,
                iconColor: AppColors.primary,
                title: 'Change MPIN',
                subtitle: 'Update your 4-digit security MPIN',
                onTap: controller.goToChangeMPIN,
              ),
              _buildSettingsTile(
                context,
                icon: Icons.lock_reset,
                iconBg: colors.withdrawalBg,
                iconColor: colors.withdrawal,
                title: 'Reset MPIN',
                subtitle: 'Clear MPIN and set a new one on next launch',
                onTap: controller.resetMPIN,
              ),
              _buildSettingsTile(
                context,
                icon: Icons.logout,
                iconBg: colors.warningBg,
                iconColor: AppColors.warning,
                title: 'Lock App',
                subtitle: 'Return to MPIN login screen',
                onTap: controller.logOut,
              ),
              const SizedBox(height: 20),
              _buildSectionTitle(context, 'Data Management'),
              _buildSettingsTile(
                context,
                icon: Icons.delete_sweep_outlined,
                iconBg: colors.withdrawalBg,
                iconColor: colors.withdrawal,
                title: 'Clear All Data',
                subtitle: 'Permanently delete all customers and transactions',
                isDanger: true,
                onTap: controller.clearAllData,
              ),
              const SizedBox(height: 20),
              _buildSectionTitle(context, 'About'),
              _buildSettingsTile(
                context,
                icon: Icons.info_outline,
                iconBg: colors.balanceBg,
                iconColor: AppColors.primary,
                title: 'App Information',
                subtitle:
                    'Version ${AppConstants.appVersion}',
                onTap: () => _showAbout(context),
                trailing: false,
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Made with ♥ for Curd Sellers',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textHint,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.textWhite.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: AppColors.textWhite,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textWhite,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Personal Curd Accounting',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFBBDEFB),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSummaryCard(BuildContext context) {
    final colors = context.colors;
    return Obx(() {
      final cust = controller.totalCustomers;
      final txns = controller.totalTransactions;
      final dep = controller.totalDeposit;
      final wd = controller.totalWithdrawal;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.divider.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.insights_outlined,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 6),
                const Text(
                  'Data Summary',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                    child: _summaryItem(
                        context, 'Customers', cust, colors.neutralText)),
                Container(width: 1, height: 30, color: colors.divider),
                Expanded(
                    child: _summaryItem(
                        context, 'Transactions', txns, AppColors.primary)),
              ],
            ),
            const Divider(height: 28),
            Row(
              children: [
                Expanded(
                  child: _summaryItem(
                      context, 'Total Deposit', '${AppConstants.rupeeSymbol}$dep',
                      colors.deposit),
                ),
                Container(width: 1, height: 30, color: colors.divider),
                Expanded(
                  child: _summaryItem(context, 'Total Withdrawal',
                      '${AppConstants.rupeeSymbol}$wd', colors.withdrawal),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _summaryItem(
      BuildContext context, String label, String value, Color color) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: colors.textHint,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 0, 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: colors.textSecondary,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _buildDarkModeTile(BuildContext context) {
    final colors = context.colors;
    return Obx(() {
      final isDark = controller.isDarkMode.value;
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.divider.withOpacity(0.5)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => controller.setDarkMode(!isDark),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colors.balanceBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dark Mode',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isDark ? 'Enabled' : 'Disabled',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isDark,
                    onChanged: (v) => controller.setDarkMode(v),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDanger = false,
    bool trailing = true,
    Widget? trailingWidget,
  }) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.divider.withOpacity(0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color:
                              isDanger ? colors.withdrawal : colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailingWidget != null)
                  trailingWidget
                else if (trailing)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: isDanger
                        ? colors.withdrawal.withOpacity(0.6)
                        : colors.textHint,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    final colors = context.colors;
    Get.dialog(
      AlertDialog(
        backgroundColor: colors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colors.balanceBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.info_outline, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            const Text('About App'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppConstants.appName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Version ${AppConstants.appVersion}',
              style: TextStyle(fontSize: 13, color: colors.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(
              'A simple, secure, and offline-first accounting app for managing daily curd-related deposits, withdrawals, and account balances for multiple customers.',
              style: TextStyle(
                  fontSize: 14, height: 1.5, color: colors.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(
              'All data is stored locally on your device using SharedPreferences. No internet connection required.',
              style: TextStyle(fontSize: 13, color: colors.textHint),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
