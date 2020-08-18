import 'dart:math';

import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/CashFlowOfDay.dart';
import 'package:expense_manager/data/models/EntryWithCategoryAndWallet.dart';
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
  PublishSubject<List<EntryWithCategoryAndWallet>> topFiveEntries = PublishSubject();
  GetBalanceEvent _balanceEvent;
  GetExpensesOfCategory _expensesOfCategoryEvent;
  GetTopFiveEntriesEvent _getTopFiveEntriesEvent;

  HomeBloc(this._repository) : super(null);

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    print(event);
    if(event is GetWalletsEvent) {
      yield* _getWalletsWithBalance();
    } else if(event is GetBalanceEvent) {
      print(event.startTime);
      print(event.endTime);
      this._balanceEvent = event;
      yield* _getCashFlow(event.startTime, event.endTime);
      yield* _getExpensesOfAllCategories(event.startTime, event.endTime);
      yield* _getTopFiveEntries(event.startTime, event.endTime);
    } else if(event is ResumeEvent) {
      yield* _getWalletsWithBalance();
      if(_balanceEvent != null) {
        yield* _getCashFlow(_balanceEvent.startTime, _balanceEvent.endTime);
        yield* _getExpensesOfAllCategories(_balanceEvent.startTime, _balanceEvent.endTime);
        yield* _getTopFiveEntries(_balanceEvent.startTime, _balanceEvent.endTime);
      }
    } else if(event is GetAccountBookEvent) {
      yield* _getCurrentAccountBook();
    } else if(event is ClearAccountBookEvent) {
      yield* _clearCurrentAccountBook();
    } else if(event is AdjustWalletBalanceEvent) {
      yield* _adjustWalletBalance(event.amount, event.mWallet);
    }
  }

  Stream<HomeState> _getWalletsWithBalance() async* {
    final result = await _repository.getWalletsWithBalance();
    print(result[0].balance);
    wallets.sink.add(result.map((e) {
      if(e.balance == null) e.balance = 0.0;
      if(e.income == null) e.income = 0.0;
      double percent = e.income > 0.0 ? (max(e.balance, 0) / e.income.abs()) : 0;
      return (e..balancePercent = percent);
    }).toList());
    yield* Stream.value(WalletsState(result));
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
    if(result != null) {
      result.forEach((element) {
        if (element.total == null) element.total = 0.0;
        if (element.name == null) element.name = "";
        if (element.color == null) element.color = 0xFFFFFF;
      });
    }
    expenses.add(result);
    yield* Stream.value(ExpenseOfCategoryState(result));
  }

  Stream<HomeState> _getTopFiveEntries(int startTime, int endTime) async* {
    final result = await _repository.getTopFiveEntries(startTime, endTime);
    yield* Stream.value(TopFiveEntriesState(entries: result));
  }

  Stream<HomeState> _getCurrentAccountBook() async* {
    final book = await _repository.getCurrentAccountBook();
    yield* Stream.value(GetAccountBookState(book));
  }

  Stream<HomeState> _clearCurrentAccountBook() async* {
    final result = await _repository.clearCurrentAccountBook();
    yield* Stream.value(ClearAccountBookState());
  }

  Stream<HomeState> _adjustWalletBalance(double amount, WalletWithBalance wallet) async* {
    double adjustedBalance = amount - wallet.balance;
    int date = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      0,
      0,
      0,
      0,
      0
    ).millisecondsSinceEpoch;
    final result = await _repository
        .adjustWalletBalance(adjustedBalance, date, wallet.mWallet.id);
    yield* _getWalletsWithBalance();
  }
}