import '../models/user_model.dart';
import '../../app/constants/app_constants.dart';

class TransactionModel {
  final String id;
  final String userId;
  final String type;
  final double amount;
  final DateTime dateTime;
  final String? note;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.dateTime,
    this.note,
  });

  bool get isDeposit => type == AppConstants.transactionTypeDeposit;
  bool get isWithdrawal => type == AppConstants.transactionTypeWithdrawal;

  String get sign => isDeposit ? '+' : '-';

  TransactionModel copyWith({
    String? id,
    String? userId,
    String? type,
    double? amount,
    DateTime? dateTime,
    String? note,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      dateTime: dateTime ?? this.dateTime,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
      'note': note,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      type: map['type'] as String,
      amount: (map['amount'] as num).toDouble(),
      dateTime: DateTime.parse(map['dateTime'] as String),
      note: map['note'] as String?,
    );
  }

  String? getUserName(List<UserModel> users) {
    try {
      return users.firstWhere((u) => u.id == userId).name;
    } catch (_) {
      return null;
    }
  }
}
