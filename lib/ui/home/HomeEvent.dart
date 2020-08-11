class HomeEvent{}

class InitialEvent extends HomeEvent {}

class GetWalletsEvent extends HomeEvent{}
class GetThisMonthBalanceEvent extends HomeEvent {
  int startTime;
  int endTime;
  GetThisMonthBalanceEvent(this.startTime, this.endTime);
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

class ResetEvent extends HomeEvent {}