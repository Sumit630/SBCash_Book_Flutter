class AppConstants {
  AppConstants._();

  static const String appName = 'SB CashBook';
  static const String appVersion = '1.0.0';
  static const int mpinLength = 4;

  static const String rupeeSymbol = '₹';

  static const String storageKeyMpin = 'curd_hisab_mpin';
  static const String storageKeyUsers = 'curd_hisab_users';
  static const String storageKeyTransactions = 'curd_hisab_transactions';
  static const String storageKeyMpinCreated = 'curd_hisab_mpin_created';
  static const String storageKeyThemeMode = 'curd_hisab_theme_dark';

  static const String transactionTypeDeposit = 'deposit';
  static const String transactionTypeWithdrawal = 'withdrawal';

  static const String filterAll = 'all';
  static const String filterDeposit = 'deposit';
  static const String filterWithdrawal = 'withdrawal';

  static const int recentTransactionLimit = 10;

  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackbarDuration = Duration(seconds: 2);
}
