import 'package:expense_manager/data/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/WalletWithBalance.dart';

abstract class HomeRepository {

  Stream<List<WalletWithBalance>> getWalletsWithBalance();
}