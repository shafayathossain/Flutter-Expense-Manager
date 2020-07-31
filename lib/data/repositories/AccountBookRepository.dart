import 'package:expense_manager/data/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/AccountBook.dart';

abstract class AccountBookRepository {

  Stream<List<account_book>> getAllAccountBooks();
  Stream<int> createAnAccountBook(account_book book);

}