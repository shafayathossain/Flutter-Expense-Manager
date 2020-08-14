import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';

class AccountBookWithBalance {

  account_book book;
  double income;
  double expense;

  AccountBookWithBalance(this.book, this.income, this.expense);

}