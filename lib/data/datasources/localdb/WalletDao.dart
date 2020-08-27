import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/Wallet.dart';
import 'package:expense_manager/data/models/WalletWithBalance.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'WalletDao.g.dart';

@UseDao(tables: [Wallet])
class WalletDao extends DatabaseAccessor<LocalDatabase> with _$WalletDaoMixin {
  LocalDatabase _database;

  WalletDao(LocalDatabase attachedDatabase) : super(attachedDatabase) {
    this._database = attachedDatabase;
  }

  Future<int> insertWallet(wallet mWallet) {
    return into(_database.wallet).insert(mWallet);
  }

  Future<List<wallet>> getWallets(int bookId) {
    final query =
        (select(_database.wallet)..where((tbl) => tbl.bookId.equals(bookId)));
    query
      ..orderBy(
          [(row) => OrderingTerm(expression: row.id, mode: OrderingMode.asc)]);

    return query.get();
  }

  Future<List<WalletWithBalance>> getWalletsWithBalance(int bookId) {
    final balance = CustomExpression<double>("SUM(entry.amount)");
    final income = CustomExpression<double>(
        "SUM(CASE WHEN entry.amount>=0 THEN entry.amount ELSE 0 END)");
    final query = (select(_database.wallet).join([
      leftOuterJoin(_database.entry,
          _database.entry.walletId.equalsExp(_database.wallet.id),
          useColumns: false)
    ])
      ..addColumns([balance, income])
      ..where(_database.wallet.bookId.equals(bookId))
      ..groupBy([_database.entry.walletId]));
    return query.map((event) {
      return WalletWithBalance(
          balance: event.read(balance),
          income: event.read(income),
          mWallet: event.readTable(_database.wallet));
    }).get();
  }
}
