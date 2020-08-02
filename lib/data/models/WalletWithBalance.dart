import 'package:expense_manager/data/localdb/LocalDatabase.dart';

class WalletWithBalance {
  wallet mWallet;
  num income;
  num balance;
  double balancePercent;

  WalletWithBalance({this.mWallet, this.balance, this.income});
}