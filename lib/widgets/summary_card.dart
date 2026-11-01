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
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.borderColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: theme.borderColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: theme.mainColor, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: theme.textSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              type == SummaryCardType.users ? value : '${AppConstants.rupeeSymbol}$value',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: theme.mainColor,
                letterSpacing: -0.3,
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
          mainColor: colors.textPrimary,
          bgColor: colors.card,
          borderColor: colors.divider,
          iconBgColor: colors.neutralBg,
          textSecondaryColor: colors.textSecondary,
        );
      case SummaryCardType.deposit:
        return _SummaryTheme(
          mainColor: colors.deposit,
          bgColor: colors.depositBg,
          borderColor: AppColors.depositLight,
          iconBgColor: AppColors.depositLight.withOpacity(0.2),
          textSecondaryColor: colors.deposit.withOpacity(0.7),
        );
      case SummaryCardType.withdrawal:
        return _SummaryTheme(
          mainColor: colors.withdrawal,
          bgColor: colors.withdrawalBg,
          borderColor: AppColors.withdrawalLight,
          iconBgColor: AppColors.withdrawalLight.withOpacity(0.2),
          textSecondaryColor: colors.withdrawal.withOpacity(0.7),
        );
      case SummaryCardType.balance:
        return _SummaryTheme(
          mainColor: colors.balance,
          bgColor: colors.balanceBg,
          borderColor: AppColors.balanceLight,
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
  final Color iconBgColor;
  final Color textSecondaryColor;
  _SummaryTheme({
    required this.mainColor,
    required this.bgColor,
    required this.borderColor,
    required this.iconBgColor,
    required this.textSecondaryColor,
  });
}
