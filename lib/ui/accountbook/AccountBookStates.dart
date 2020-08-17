

import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/account_book_with_balance.dart';

abstract class AccountBookStates {
  const AccountBookStates();
}

class AccountBookLoadedState extends AccountBookStates {
  List<AccountBookWithBalance> accountBooks = [];
}

class ViewBookState extends AccountBookStates {}

class ExportEntriesState extends AccountBookStates {

  List<List<dynamic>> row;
  String bookName;

  ExportEntriesState(this.row, this.bookName);
}