import 'package:hive_flutter/hive_flutter.dart';

part 'transaction.g.dart'; // Для генерации адаптера Hive

@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String type; // 'income' или 'expense'

  Transaction({
    required this.title,
    required this.amount,
    required this.type,
  });
}