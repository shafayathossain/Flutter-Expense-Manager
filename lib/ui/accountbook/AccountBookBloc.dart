import 'dart:async';

import 'package:expense_manager/data/datasources/localdb/AccountBookDao.dart';
import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
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

    if(event is CreateAccountBookEvent) {
     yield* _createABook(event.name, event.color);
    } else if(event is LoadAccountBookEvent) {
      yield* _getAllBooks();
    } else if(event is ViewAccountBookEvent) {
      yield* _saveCurrentAccountBook(event.book);
    } else if(event is DeleteAccountBookEvent) {
      yield* _deleteABook(event.book);
    } else if(event is EditAccountBookEvent) {
      yield* _updateABook(event.name, event.color, event.id);
    }
  }

  @override
  Future<void> close() {

    return super.close();
  }

  Stream<AccountBookStates> _getAllBooks() async* {
    final result = await repository.getAllAccountBooks();
    yield AccountBookLoadedState()..accountBooks = result;

  }

  Stream<AccountBookStates> _createABook(String name, int color) async* {
    account_book book = account_book(
      id: new DateTime.now().millisecondsSinceEpoch,
      name: name,
      color: color,
      creationDate: DateTime.now().millisecondsSinceEpoch
    );

    await for(int event in repository.createAnAccountBook(book)) {
      yield* _getAllBooks();
    }
  }


  Stream<AccountBookStates> _updateABook(String name, int color, int id) async* {
    account_book book = account_book(
        id: id,
        name: name,
        color: color,
    );
    final result = await repository.editAnAccountBook(book);
    yield* _getAllBooks();
  }

  Stream<AccountBookStates> _saveCurrentAccountBook(account_book book) async* {
    int result = await repository.saveCurrentAccountBook(book);
    yield* Stream.value(ViewBookState());
  }

  Stream<AccountBookStates> _deleteABook(account_book book) async* {
    final result = await repository.deleteAnAccountBook(book);
    yield* _getAllBooks();
  }

}