import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'transaction.dart';

class FinanceCubit extends Cubit<List<Transaction>> {
  final Box<Transaction> _box;

  FinanceCubit(this._box) : super(_box.values.toList()) {
    _box.watch().listen((event) => emit(_box.values.toList()));
  }

  void addTransaction(Transaction transaction) {
    _box.add(transaction);
  }

  void deleteTransaction(int key) {
    _box.delete(key);
  }

  List<Transaction> getFilteredTransactions(String? filterType) {
    if (filterType == null) return state;
    return state.where((t) => t.type == filterType).toList();
  }
}