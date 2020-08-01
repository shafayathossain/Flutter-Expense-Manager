import 'package:expense_manager/data/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/Wallet.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'WalletDao.g.dart';

@UseDao(tables: [Wallet])
class WalletDao extends DatabaseAccessor<LocalDatabase> with _$WalletDaoMixin {

  LocalDatabase _database;

  WalletDao(LocalDatabase attachedDatabase): super(attachedDatabase) {
    this._database = attachedDatabase;
  }

  Stream<List<wallet>> getWallets(int bookId) {
    return (select(_database.wallet))
        .get().asStream();
  }

}