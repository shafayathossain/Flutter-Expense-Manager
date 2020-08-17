import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/EntryWithCategoryAndWallet.dart';
import 'package:expense_manager/data/models/account_book_with_balance.dart';

abstract class AccountBookRepository {

  Future<List<AccountBookWithBalance>> getAllAccountBooks();
  Stream<int> createAnAccountBook(account_book book);
  Future<int> editAnAccountBook(account_book book);
  Future<int> saveCurrentAccountBook(account_book book);
  Future<void> deleteAnAccountBook(account_book book);
  Future<account_book> getCurrentBook();
  Future<List<EntryWithCategoryAndWallet>> getAllEntries(int bookId);

}