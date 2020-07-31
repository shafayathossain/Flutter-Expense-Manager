import 'package:expense_manager/data/localdb/AccountBookDao.dart';
import 'package:expense_manager/data/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/AccountBook.dart';
import 'package:expense_manager/data/repositories/AccountBookRepository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountBookRepositoryImpl extends AccountBookRepository {

  AccountBookRepositoryImpl(this.context) {
    _accountBookDao = AccountBookDao(context.read<LocalDatabase>());
  }

  final BuildContext context;
  AccountBookDao _accountBookDao;

  @override
  Stream<List<account_book>> getAllAccountBooks() {
    return _accountBookDao.getAllAccountBooks();
  }

  @override
  Stream<int> createAnAccountBook(account_book book) {
    return _accountBookDao.insert(book);
  }
}