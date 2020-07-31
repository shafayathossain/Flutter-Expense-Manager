import 'dart:async';

import 'package:expense_manager/data/localdb/AccountBookDao.dart';
import 'package:expense_manager/data/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/AccountBook.dart';
import 'package:expense_manager/data/repositories/AccountBookRepository.dart';
import 'package:expense_manager/ui/accountbook/AccountBookEvents.dart';
import 'package:expense_manager/ui/accountbook/AccountBookStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class AccountBookBloc extends Bloc<AccountBookEvents, AccountBookStates> {

  AccountBookBloc(this.repository) : super(null);

  final AccountBookRepository repository;

  @override
  Stream<AccountBookStates> mapEventToState(AccountBookEvents event) async* {
    print(event);
    if(event is CreateAccountBookEvent) {
     yield* _createABook(event.name, event.color);
    } else if(event is LoadAccountBookEvent) {
      yield* _getAllBooks();
    }
  }

  @override
  Future<void> close() {
    print("CLose");
    return super.close();
  }

  Stream<AccountBookStates> _getAllBooks() async* {
    await for(List<account_book> event in repository.getAllAccountBooks()) {
      yield AccountBookLoadedState()..accountBooks = event;
    }
  }

  Stream<AccountBookStates> _createABook(String name, int color) async* {
    account_book book = account_book(
      id: new DateTime.now().millisecondsSinceEpoch,
      name: name,
      color: color,
      creationDate: DateTime.now().millisecondsSinceEpoch
    );
    print(book);
    await for(int event in repository.createAnAccountBook(book)) {
      print(event);
      yield* _getAllBooks();
    }
  }

}