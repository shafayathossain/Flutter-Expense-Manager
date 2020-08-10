import 'package:expense_manager/data/models/CashFlowOfDay.dart';
import 'package:expense_manager/data/models/ExpenseOfCategory.dart';
import 'package:expense_manager/data/models/WalletWithBalance.dart';
import 'package:expense_manager/data/repositories/HomeRepository.dart';
import 'package:expense_manager/ui/home/HomeEvent.dart';
import 'package:expense_manager/ui/home/HomeState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeRepository _repository;
  PublishSubject<List<WalletWithBalance>> wallets = PublishSubject();
  PublishSubject<List<double>> incomeAndExpenses = new PublishSubject();
  PublishSubject<List<CashFlowOfDay>> cashFlowData = PublishSubject();
  PublishSubject<List<ExpenseOfCategory>> expenses = PublishSubject();

  HomeBloc(this._repository) : super(null);

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if(event is GetWalletsEvent) {
      yield* _getWalletsWithBalance();
    } else if(event is GetThisMonthBalanceEvent) {
      yield* _getCashFlow(event.startTime, event.endTime);
    } else if(event is GetExpensesOfCategory) {
      yield* _getExpensesOfAllCategories(event.startTime, event.endTime);
    }
  }

  Stream<HomeState> _getWalletsWithBalance() async* {
    yield* _repository.getWalletsWithBalance().map((event) {
      wallets.sink.add(event.map((e) {
        double percent = e.income > 0.0 ? (e.balance.abs() / e.income.abs()) : 0;
        return (e..balancePercent = percent);
      }).toList());
      return HomeState();
    });
  }

  Stream<HomeState> _getCashFlow(int startTime, int endTime) async* {
    List<CashFlowOfDay> event = await _repository.getCashFlow(startTime, endTime);
    List<CashFlowOfDay> cashFlow  = [];
    DateTime startDateTime = DateTime.fromMillisecondsSinceEpoch(startTime);
    DateTime endDateTime = DateTime.fromMillisecondsSinceEpoch(endTime);
    double income = 0;
    double expense = 0;
    event.forEach((element) {
      if(element.income != null && element.expense != null) {
        income += element.income.abs();
        expense += element.expense.abs();
      }
    });
    incomeAndExpenses.add([income, expense]);
    double balance = 0.0;
    while(startDateTime.millisecondsSinceEpoch <= endTime) {

      CashFlowOfDay result = event
          .firstWhere(
              (element) => element.date == startDateTime.millisecondsSinceEpoch,
              orElse: () => (CashFlowOfDay(
                  0.0,
                  0.0,
                  startDateTime.millisecondsSinceEpoch))
      );
      balance += result.income.abs() - result.expense.abs();
      cashFlow.add(result..balance = balance);
      startDateTime = startDateTime.add(Duration(days: 1));
    }
    this.cashFlowData.sink.add(cashFlow);
    yield* Stream.value(CashFlowState(income, expense));
  }

  Stream<HomeState> _getExpensesOfAllCategories(int startTime, int endTime) async* {
    List<ExpenseOfCategory> result = await _repository.getTotalExpenseForAllCategories(startTime, endTime);
    expenses.add(result);
    yield* Stream.value(ExpenseOfCategoryState(result));
  }
}