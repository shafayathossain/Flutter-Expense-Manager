
import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/AccountBook.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:rxdart/rxdart.dart';

part 'AccountBookDao.g.dart';

@UseDao(tables: [AccountBook])
class AccountBookDao extends DatabaseAccessor<LocalDatabase> {

  LocalDatabase _database;

  AccountBookDao(LocalDatabase attachedDatabase) : super(attachedDatabase) {
    this._database = attachedDatabase;
  }

  Stream<List<account_book>> getAllAccountBooks() {
    return select(_database.accountBook).get().asStream();
  }

  Stream<int> insert(Insertable<account_book> book) {
    return into(_database.accountBook).insert(book).asStream();
  }

  Future<int> editAnAccountBook(account_book book) {
    return (update(_database.accountBook)
      ..where((tbl) => tbl.id.equals(book.id))
    ).write(AccountBookCompanion(
      color: Value(book.color),
      name: Value(book.name)
    ));
  }

  Future<void> deleteAnAccountBook(account_book book) {
    return batch((batch) {
      batch.deleteWhere(_database.accountBook, (row) => row.id.equals(book.id));
      batch.deleteWhere(_database.wallet, (row) => row.bookId.equals(book.id));
      batch.deleteWhere(_database.entry, (row) => row.bookId.equals(book.id));
      batch.deleteWhere(_database.category, (row) => row.bookId.equals(book.id));
      batch.deleteWhere(_database.tag, (row) => row.bookId.equals(book.id));
    });
  }
}