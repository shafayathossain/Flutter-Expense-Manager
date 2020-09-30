import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/AccountBook.dart';
import 'package:expense_manager/data/models/Entry.dart';
import 'package:expense_manager/data/models/account_book_with_balance.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'AccountBookDao.g.dart';

@UseDao(tables: [AccountBook, Entry])
class AccountBookDao extends DatabaseAccessor<LocalDatabase>
    with _$AccountBookDaoMixin {
  LocalDatabase _database;

  AccountBookDao(LocalDatabase attachedDatabase) : super(attachedDatabase) {
    this._database = attachedDatabase;
  }

  Future<List<AccountBookWithBalance>> getAllAccountBooks() {
    final income = CustomExpression<double>(
        "SUM(CASE WHEN entry.amount>=0 THEN entry.amount ELSE 0 END)");
    final expense = CustomExpression<double>(
        "SUM(CASE WHEN entry.amount<=0 THEN entry.amount ELSE 0 END)");
    final query = customSelect(
        "SELECT account_book.*, SUM(CASE WHEN entry.amount>=0 THEN entry.amount ELSE 0 END) AS income, SUM(CASE WHEN entry.amount<=0 THEN entry.amount ELSE 0 END) AS expense FROM account_book INNER JOIN entry ON account_book.id = entry.book_id UNION ALL SELECT account_book.*, 0 as income, 0 as expense FROM account_book WHERE account_book.id NOT IN (SELECT entry.book_id FROM entry) AND account_book.id IS NOT NULL ORDER BY id",
        readsFrom: {_database.accountBook, _database.entry});
    // final query = select(_database.accountBook).join([
    //   leftOuterJoin(_database.entry,
    //       _database.entry.bookId.equalsExp(_database.accountBook.id))
    // ])
    //   ..addColumns([income, expense]);
    return query.map((event) {
      print(event.data);
      return AccountBookWithBalance(
          account_book.fromData(event.data, this._database),
          event.readDouble("income"),
          event.readDouble("expense"));
    }).get();
  }

  Stream<int> insert(Insertable<account_book> book) {
    return into(_database.accountBook).insert(book).asStream();
  }

  Future<int> editAnAccountBook(account_book book) {
    return (update(_database.accountBook)
          ..where((tbl) => tbl.id.equals(book.id)))
        .write(AccountBookCompanion(
            color: Value(book.color), name: Value(book.name)));
  }

  Future<void> deleteAnAccountBook(account_book book) {
    return batch((batch) {
      batch.deleteWhere(_database.accountBook, (row) => row.id.equals(book.id));
      batch.deleteWhere(_database.wallet, (row) => row.bookId.equals(book.id));
      batch.deleteWhere(_database.entry, (row) => row.bookId.equals(book.id));
      batch.deleteWhere(
          _database.category, (row) => row.bookId.equals(book.id));
      batch.deleteWhere(_database.tag, (row) => row.bookId.equals(book.id));
    });
  }
}
