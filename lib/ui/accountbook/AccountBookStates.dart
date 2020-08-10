

import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';

abstract class AccountBookStates {
  const AccountBookStates();
}

class AccountBookLoadedState extends AccountBookStates {
  List<account_book> accountBooks = [];
}

class ViewBookState extends AccountBookStates {}