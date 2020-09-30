import 'dart:async';

import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/account_book_with_balance.dart';
import 'package:expense_manager/data/repositories/AccountBookRepository.dart';
import 'package:expense_manager/ui/accountbook/AccountBookEvents.dart';
import 'package:expense_manager/ui/accountbook/AccountBookStates.dart';
import 'package:expense_manager/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountBookBloc extends Bloc<AccountBookEvents, AccountBookStates> {
  AccountBookBloc(this.repository) : super(null);

  final AccountBookRepository repository;

  @override
  Stream<AccountBookStates> mapEventToState(AccountBookEvents event) async* {
    if (event is CreateAccountBookEvent) {
      yield* _createABook(event.name, event.color);
    } else if (event is LoadAccountBookEvent) {
      yield* _getAllBooks();
    } else if (event is ViewAccountBookEvent) {
      yield* _saveCurrentAccountBook(event.book);
    } else if (event is DeleteAccountBookEvent) {
      yield* _deleteABook(event.book);
    } else if (event is EditAccountBookEvent) {
      yield* _updateABook(event.name, event.color, event.id);
    } else if (event is ExportAccountBookEvent) {
      yield* _exportEntries(event.book);
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }

  Stream<AccountBookStates> _getAllBooks() async* {
    final result = await repository.getAllAccountBooks();
    List<AccountBookWithBalance> tempList = [];
    result.forEach((element) {
      if (element.book.id != null) {
        tempList.add(element);
      }
    });
    yield AccountBookLoadedState()..accountBooks = tempList;
  }

  Stream<AccountBookStates> _createABook(String name, int color) async* {
    account_book book = account_book(
        id: new DateTime.now().millisecondsSinceEpoch,
        name: name,
        color: color,
        creationDate: DateTime.now().millisecondsSinceEpoch);

    await for (int event in repository.createAnAccountBook(book)) {
      yield* _getAllBooks();
    }
  }

  Stream<AccountBookStates> _updateABook(
      String name, int color, int id) async* {
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

  Stream<AccountBookStates> _exportEntries(account_book book) async* {
    final result = await repository.getAllEntries(book.id);
    final rowHeads = ["Date", "Name", "Tag", "Amount", "Wallet", "Description"];
    List<List<dynamic>> rows = [rowHeads];

    String previousDate = "";
    result.forEach((element) {
      String tempDate = Convert(element.mEntry.date).toDateString();
      if (tempDate != previousDate) {
        previousDate = tempDate;
      } else {
        tempDate = "";
      }
      final row = [
        tempDate,
        element.mCategory.name,
        element.mTag == null ? "" : element.mTag.name,
        element.mEntry.amount,
        element.mWallet.name,
        element.mEntry.description == null ? "" : element.mEntry.description
      ];
      rows.add(row);
    });
    yield* Stream.value(ExportEntriesState(rows, book.name));
  }
}
