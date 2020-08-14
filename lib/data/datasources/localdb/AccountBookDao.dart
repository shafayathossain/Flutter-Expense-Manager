
import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/AccountBook.dart';
import 'package:expense_manager/data/models/Entry.dart';
import 'package:expense_manager/data/models/account_book_with_balance.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:rxdart/rxdart.dart';

part 'AccountBookDao.g.dart';

@UseDao(tables: [AccountBook, Entry])
class AccountBookDao extends DatabaseAccessor<LocalDatabase> with _$AccountBookDaoMixin {

  LocalDatabase _database;

  AccountBookDao(LocalDatabase attachedDatabase) : super(attachedDatabase) {
    this._database = attachedDatabase;
  }

  Future<List<AccountBookWithBalance>> getAllAccountBooks() {

    final income = CustomExpression<double>("SUM(CASE WHEN entry.amount>=0 THEN entry.amount ELSE 0 END)");
    final expense = CustomExpression<double>("SUM(CASE WHEN entry.amount<=0 THEN entry.amount ELSE 0 END)");

    final query = select(_database.accountBook)
        .join(
          [
            leftOuterJoin(_database.entry,
                          _database.entry.bookId.equalsExp(
                            _database.accountBook.id
                          )
            )
          ]
        )..addColumns([income, expense]);
    return query.map((event) {
      return AccountBookWithBalance(
        event.readTable(_database.accountBook),
        event.read(income),
        event.read(expense)
      );
    }).get();
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