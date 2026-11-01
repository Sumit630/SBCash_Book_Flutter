import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1E88E5);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color secondary = Color(0xFF263238);
  static const Color accent = Color(0xFFFF9800);

  static const Color deposit = Color(0xFF2E7D32);
  static const Color depositLight = Color(0xFF81C784);
  static const Color depositBg = Color(0xFFE8F5E9);

  static const Color withdrawal = Color(0xFFC62828);
  static const Color withdrawalLight = Color(0xFFEF5350);
  static const Color withdrawalBg = Color(0xFFFFEBEE);

  static const Color balance = Color(0xFF1565C0);
  static const Color balanceLight = Color(0xFF64B5F6);
  static const Color balanceBg = Color(0xFFE3F2FD);

  static const Color customers = Color(0xFF8054C7);
  static const Color customersLight = Color(0xFFB39DDB);
  static const Color customersBg = Color(0xFFF3EAFE);

  static const Color background = Color(0xFFF5F7FA);
  static const Color card = Colors.white;
  static const Color scaffold = Color(0xFFF5F7FA);

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF616161);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textWhite = Colors.white;

  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF0288D1);

  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFBDBDBD);
  static const Color shadow = Color(0x1A000000);

  static const Color mpinActive = Color(0xFF1E88E5);
  static const Color mpinInactive = Color(0xFFBDBDBD);
  static const Color mpinError = Color(0xFFD32F2F);

  // ---- Dark theme neutral surfaces ----
  static const Color darkScaffold = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFECEFF1);
  static const Color darkTextSecondary = Color(0xFFB0BEC5);
  static const Color darkTextHint = Color(0xFF78909C);
  static const Color darkDivider = Color(0xFF2C2C2C);
  static const Color darkBorder = Color(0xFF3A3A3A);
  static const Color darkShadow = Color(0x66000000);

  // ---- Dark theme tinted surfaces / accents ----
  static const Color neutralBg = Color(0xFFECEFF1);
  static const Color darkNeutralBg = Color(0xFF2A2E33);
  static const Color warningBg = Color(0xFFFFF3E0);
  static const Color darkWarningBg = Color(0xFF3A2A16);
  static const Color depositAccent = Color(0xFF66BB6A);
  static const Color darkDepositBg = Color(0xFF1B3A20);
  static const Color withdrawalAccent = Color(0xFFEF5350);
  static const Color darkWithdrawalBg = Color(0xFF3B1F1F);
  static const Color balanceAccent = Color(0xFF64B5F6);
  static const Color darkBalanceBg = Color(0xFF16324F);

  static const Color customersAccent = Color(0xFFD1C4E9);
  static const Color darkCustomersBg = Color(0xFF292039);
}

/// Theme-aware semantic colors resolved through [ThemeData.extensions].
///
/// Screens and widgets should read these via `context.colors` instead of
/// referencing [AppColors] directly, so the whole app reacts to Light/Dark
/// theme changes. The [light] palette mirrors the existing [AppColors]
/// constants, so the Light theme looks exactly as before.
@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color scaffold;
  final Color card;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color divider;
  final Color border;
  final Color shadow;
  final Color neutralBg;
  final Color warningBg;
  final Color neutralText;
  final Color deposit;
  final Color depositBg;
  final Color withdrawal;
  final Color withdrawalBg;
  final Color balance;
  final Color balanceBg;
  final Color customers;
  final Color customersBg;

  const AppThemeColors({
    required this.scaffold,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.divider,
    required this.border,
    required this.shadow,
    required this.neutralBg,
    required this.warningBg,
    required this.neutralText,
    required this.deposit,
    required this.depositBg,
    required this.withdrawal,
    required this.withdrawalBg,
    required this.balance,
    required this.balanceBg,
    required this.customers,
    required this.customersBg,
  });

  static const AppThemeColors light = AppThemeColors(
    scaffold: AppColors.scaffold,
    card: AppColors.card,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textHint: AppColors.textHint,
    divider: AppColors.divider,
    border: AppColors.border,
    shadow: AppColors.shadow,
    neutralBg: AppColors.neutralBg,
    warningBg: AppColors.warningBg,
    neutralText: AppColors.secondary,
    deposit: AppColors.deposit,
    depositBg: AppColors.depositBg,
    withdrawal: AppColors.withdrawal,
    withdrawalBg: AppColors.withdrawalBg,
    balance: AppColors.balance,
    balanceBg: AppColors.balanceBg,
    customers: AppColors.customers,
    customersBg: AppColors.customersBg,
  );

  static const AppThemeColors dark = AppThemeColors(
    scaffold: AppColors.darkScaffold,
    card: AppColors.darkCard,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    textHint: AppColors.darkTextHint,
    divider: AppColors.darkDivider,
    border: AppColors.darkBorder,
    shadow: AppColors.darkShadow,
    neutralBg: AppColors.darkNeutralBg,
    warningBg: AppColors.darkWarningBg,
    neutralText: AppColors.darkTextPrimary,
    deposit: AppColors.depositAccent,
    depositBg: AppColors.darkDepositBg,
    withdrawal: AppColors.withdrawalAccent,
    withdrawalBg: AppColors.darkWithdrawalBg,
    balance: AppColors.balanceAccent,
    balanceBg: AppColors.darkBalanceBg,
    customers: AppColors.customersAccent,
    customersBg: AppColors.darkCustomersBg,
  );

  @override
  AppThemeColors copyWith({
    Color? scaffold,
    Color? card,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? divider,
    Color? border,
    Color? shadow,
    Color? neutralBg,
    Color? warningBg,
    Color? neutralText,
    Color? deposit,
    Color? depositBg,
    Color? withdrawal,
    Color? withdrawalBg,
    Color? balance,
    Color? balanceBg,
    Color? customers,
    Color? customersBg,
  }) {
    return AppThemeColors(
      scaffold: scaffold ?? this.scaffold,
      card: card ?? this.card,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      divider: divider ?? this.divider,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      neutralBg: neutralBg ?? this.neutralBg,
      warningBg: warningBg ?? this.warningBg,
      neutralText: neutralText ?? this.neutralText,
      deposit: deposit ?? this.deposit,
      depositBg: depositBg ?? this.depositBg,
      withdrawal: withdrawal ?? this.withdrawal,
      withdrawalBg: withdrawalBg ?? this.withdrawalBg,
      balance: balance ?? this.balance,
      balanceBg: balanceBg ?? this.balanceBg,
      customers: customers ?? this.customers,
      customersBg: customersBg ?? this.customersBg,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      scaffold: Color.lerp(scaffold, other.scaffold, t)!,
      card: Color.lerp(card, other.card, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      border: Color.lerp(border, other.border, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      neutralBg: Color.lerp(neutralBg, other.neutralBg, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      neutralText: Color.lerp(neutralText, other.neutralText, t)!,
      deposit: Color.lerp(deposit, other.deposit, t)!,
      depositBg: Color.lerp(depositBg, other.depositBg, t)!,
      withdrawal: Color.lerp(withdrawal, other.withdrawal, t)!,
      withdrawalBg: Color.lerp(withdrawalBg, other.withdrawalBg, t)!,
      balance: Color.lerp(balance, other.balance, t)!,
      balanceBg: Color.lerp(balanceBg, other.balanceBg, t)!,
      customers: Color.lerp(customers, other.customers, t)!,
      customersBg: Color.lerp(customersBg, other.customersBg, t)!,
    );
  }
}

/// Convenience accessor for the active [AppThemeColors] palette.
extension AppThemeColorsX on BuildContext {
  AppThemeColors get colors =>
      Theme.of(this).extension<AppThemeColors>() ?? AppThemeColors.light;
}
