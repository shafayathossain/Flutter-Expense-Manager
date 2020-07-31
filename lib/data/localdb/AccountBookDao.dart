
import 'package:expense_manager/data/localdb/LocalDatabase.dart';
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
    return into(_database.accountBook).insert(book).asStream()
    .doOnError((error) {
      print(error);
    });
  }
}