class HomeState {}

class LoadingState extends HomeState {}

class CashFlowState extends HomeState {
  double income;
  double expense;
  CashFlowState(this.income, this.expense);
}