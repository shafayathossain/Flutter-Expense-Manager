

import 'package:expense_manager/data/localdb/LocalDatabase.dart';

abstract class AccountBookStates {
  const AccountBookStates();
}

class AccountBookLoadedState extends AccountBookStates {
  List<account_book> accountBooks = [];
}