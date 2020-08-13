import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/repositories/AccountBookRepository.dart';
import 'package:expense_manager/ui/splash/splash_event.dart';
import 'package:expense_manager/ui/splash/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {

  AccountBookRepository _repository;

  SplashBloc(this._repository): super(null);

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    yield* getCurrentBookId();
  }

  Stream<SplashState> getCurrentBookId() async* {
    account_book book = await _repository.getCurrentBook();
    yield* Stream.value(SplashState(bookId: book != null ? book.id : null));
  }
}