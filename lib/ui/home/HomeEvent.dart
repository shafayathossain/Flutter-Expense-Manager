class HomeEvent{}

class GetWalletsEvent extends HomeEvent{}
class GetThisMonthBalanceEvent extends HomeEvent {
  int startTime;
  int endTime;
  GetThisMonthBalanceEvent(this.startTime, this.endTime);
}

class GetThisYearBalanceEvent extends HomeEvent {
  int startTime;
  int endTime;
  GetThisYearBalanceEvent(this.startTime, this.endTime);
}