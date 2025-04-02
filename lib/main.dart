import 'package:finance_app_practical_work/finance_cubit.dart';
import 'package:finance_app_practical_work/finance_screen.dart';
import 'package:finance_app_practical_work/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter()); // Регистрируем адаптер
  await Hive.openBox<Transaction>('transactions'); // Открываем коробку для транзакций

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider<FinanceCubit>(
        create: (context) => FinanceCubit(Hive.box<Transaction>('transactions')), // Создаем FinanceCubit
        child: FinanceScreen(),
      ),
    );
  }
}