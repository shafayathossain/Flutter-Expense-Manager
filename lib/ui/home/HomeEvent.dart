import 'package:expense_manager/data/models/WalletWithBalance.dart';

class HomeEvent {}

class InitialEvent extends HomeEvent {}

class GetWalletsEvent extends HomeEvent {}

class GetBalanceEvent extends HomeEvent {
  int startTime;
  int endTime;
  GetBalanceEvent(this.startTime, this.endTime);
}

class GetCashFlowEvent extends HomeEvent {
  int startTime;
  int endTime;
  GetCashFlowEvent(this.startTime, this.endTime);
}

class GetThisYearBalanceEvent extends HomeEvent {
  int startTime;
  int endTime;
  GetThisYearBalanceEvent(this.startTime, this.endTime);
}

class GetExpensesOfCategory extends HomeEvent {
  int startTime;
  int endTime;

  GetExpensesOfCategory(this.startTime, this.endTime);
}

class GetTopFiveEntriesEvent extends HomeEvent {
  int startTime;
  int endTime;

  GetTopFiveEntriesEvent(this.startTime, this.endTime);
}

class GetAccountBookEvent extends HomeEvent {}

class ClearAccountBookEvent extends HomeEvent {}

class ResetEvent extends HomeEvent {}

class ResumeEvent extends HomeEvent {}

class AdjustWalletBalanceEvent extends HomeEvent {
  double amount;
  WalletWithBalance mWallet;

  AdjustWalletBalanceEvent(this.amount, this.mWallet);
}

class CreateWalletEvent extends HomeEvent {
  String name;
  int color;
  CreateWalletEvent(this.name, this.color);
}
