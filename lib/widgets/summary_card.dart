import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/constants/app_constants.dart';

enum SummaryCardType { users, deposit, withdrawal, balance }

class SummaryCard extends StatelessWidget {
  final SummaryCardType type;
  final String value;
  final String label;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.type,
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = _getTheme(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.borderColor.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.borderColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.iconColor, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: theme.textSecondaryColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              type == SummaryCardType.users ? value : '${AppConstants.rupeeSymbol}$value',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: theme.mainColor,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _SummaryTheme _getTheme(BuildContext context) {
    final colors = context.colors;

    switch (type) {
      case SummaryCardType.users:
        return _SummaryTheme(
          mainColor: colors.customers,
          bgColor: colors.customersBg,
          borderColor: AppColors.customersLight,
          iconColor: colors.customers,
          iconBgColor: AppColors.customersLight.withOpacity(0.2),
          textSecondaryColor: colors.customers.withOpacity(0.7),
        );
      case SummaryCardType.deposit:
        return _SummaryTheme(
          mainColor: colors.deposit,
          bgColor: colors.depositBg,
          borderColor: AppColors.depositLight,
          iconColor: colors.deposit,
          iconBgColor: AppColors.depositLight.withOpacity(0.2),
          textSecondaryColor: colors.deposit.withOpacity(0.7),
        );
      case SummaryCardType.withdrawal:
        return _SummaryTheme(
          mainColor: colors.withdrawal,
          bgColor: colors.withdrawalBg,
          borderColor: AppColors.withdrawalLight,
          iconColor: colors.withdrawal,
          iconBgColor: AppColors.withdrawalLight.withOpacity(0.2),
          textSecondaryColor: colors.withdrawal.withOpacity(0.7),
        );
      case SummaryCardType.balance:
        return _SummaryTheme(
          mainColor: colors.balance,
          bgColor: colors.balanceBg,
          borderColor: AppColors.balanceLight,
          iconColor: colors.balance,
          iconBgColor: AppColors.balanceLight.withOpacity(0.2),
          textSecondaryColor: colors.balance.withOpacity(0.7),
        );
    }
  }
}

class _SummaryTheme {
  final Color mainColor;
  final Color bgColor;
  final Color borderColor;
  final Color iconColor;
  final Color iconBgColor;
  final Color textSecondaryColor;
  _SummaryTheme({
    required this.mainColor,
    required this.bgColor,
    required this.borderColor,
    required this.iconColor,
    required this.iconBgColor,
    required this.textSecondaryColor,
  });
}
