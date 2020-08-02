import 'package:expense_manager/data/models/WalletWithBalance.dart';
import 'package:expense_manager/data/repositories/HomeRepository.dart';
import 'package:expense_manager/ui/home/HomeEvent.dart';
import 'package:expense_manager/ui/home/HomeState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeRepository _repository;
  PublishSubject<List<WalletWithBalance>> wallets = PublishSubject();

  HomeBloc(this._repository): super(null);

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if(event is GetWalletsEvent) {
      yield* _getWalletsWithBalance();
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
}