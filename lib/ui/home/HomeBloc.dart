import 'package:expense_manager/data/models/CashFlowOfDay.dart';
import 'package:expense_manager/data/models/WalletWithBalance.dart';
import 'package:expense_manager/data/repositories/HomeRepository.dart';
import 'package:expense_manager/ui/home/HomeEvent.dart';
import 'package:expense_manager/ui/home/HomeState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeRepository _repository;
  PublishSubject<List<WalletWithBalance>> wallets = PublishSubject();
  PublishSubject<List<double>> incomeAndExpenses = PublishSubject()
    ..add([0, 0]);

  HomeBloc(this._repository) : super(null);

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    print("-------> $event");
    if(event is GetWalletsEvent) {
      yield* _getWalletsWithBalance();
    } else if(event is GetThisMonthBalanceEvent) {
      yield* _getCashFlow(event.startTime, event.endTime);
    } else if(event is InitialEvent) {
      yield* Stream.value(InitState());
    } else if(event is ResetEvent) {
      yield* Stream.value(ResetState());
    }
  }

  Stream<HomeState> _getWalletsWithBalance() async* {
    yield* _repository.getWalletsWithBalance().map((event) {
      wallets.sink.add(event.map((e) {
        double percent = e.income > 0.0 ? (e.balance.abs() / e.income.abs()) : 0;
        print("PERCENT $percent");
        return (e..balancePercent = percent);
      }).toList());
      return HomeState();
    });
  }

  Stream<HomeState> _getCashFlow(int startTime, int endTime) async* {
    yield* _repository.getCashFlow(startTime, endTime)
      .map((event) {
        double income = 0;
        double expense = 0;
        event.forEach((element) {
          if(element.income != null && element.expense != null) {
            income += element.income.abs();
            expense += element.expense.abs();
          }
        });
        incomeAndExpenses.add([income, expense]);
        return CashFlowState(income, expense);
      })
    .doOnError((e) {
      print(e);
    });
  }
}