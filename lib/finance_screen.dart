import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'finance_cubit.dart';
import 'transaction.dart';

class FinanceScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Personal Finance')),
      body: Column(
        children: [
          _TransactionForm(),
          Expanded(child: _TransactionList()),
        ],
      ),
    );
  }
}

class _TransactionForm extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Amount'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _addTransaction(context, 'income'),
                child: Text('Add Income'),
              ),
              ElevatedButton(
                onPressed: () => _addTransaction(context, 'expense'),
                child: Text('Add Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addTransaction(BuildContext context, String type) {
    final cubit = context.read<FinanceCubit>();
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    if (title.isNotEmpty && amount > 0) {
      cubit.addTransaction(Transaction(title: title, amount: amount, type: type));
      _titleController.clear();
      _amountController.clear();
    }
  }
}

class _TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceCubit, List<Transaction>>(
      builder: (context, transactions) {
        final totalBalance = transactions.fold<double>(
          0.0,
          (sum, t) => t.type == 'income' ? sum + t.amount : sum - t.amount,
        );

        return Column(
          children: [
            Text('Total Balance: $totalBalance'),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return ListTile(
                    title: Text(transaction.title),
                    subtitle: Text('${transaction.type}: ${transaction.amount}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => context.read<FinanceCubit>().deleteTransaction(index),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}