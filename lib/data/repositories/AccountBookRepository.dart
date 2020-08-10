import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';

abstract class AccountBookRepository {

  Stream<List<account_book>> getAllAccountBooks();
  Stream<int> createAnAccountBook(account_book book);
  Future<int> saveCurrentAccountBook(account_book book);

}