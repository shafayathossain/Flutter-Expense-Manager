import 'package:expense_manager/data/models/EntryWithCategoryAndWallet.dart';
import 'package:expense_manager/data/models/ExpenseOfCategory.dart';

class HomeState {}

class InitState extends HomeState {}

class LoadingState extends HomeState {}

class CashFlowState extends HomeState {
  double income;
  double expense;
  List<double> data = [];

  CashFlowState(this.income, this.expense) {
    data..add(income)..add(expense);
  }
}

class ExpenseOfCategoryState extends HomeState {
  List<ExpenseOfCategory> expenses;

  ExpenseOfCategoryState(this.expenses);
}

class TopFiveEntriesState extends HomeState {
  List<EntryWithCategoryAndWallet> entries = [];

  TopFiveEntriesState({this.entries});
}

class ResetState extends HomeState {}