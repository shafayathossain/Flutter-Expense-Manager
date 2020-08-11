import 'package:expense_manager/data/datasources/app_preference.dart';
import 'package:expense_manager/data/datasources/localdb/EntryDao.dart';
import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/datasources/localdb/WalletDao.dart';
import 'package:expense_manager/data/models/CashFlowOfDay.dart';
import 'package:expense_manager/data/models/EntryWithCategoryAndWallet.dart';
import 'package:expense_manager/data/models/ExpenseOfCategory.dart';
import 'package:expense_manager/data/models/WalletWithBalance.dart';
import 'package:expense_manager/data/repositories/HomeRepository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class HomeRepositoryImpl extends HomeRepository {

  WalletDao _walletDao;
  EntryDao _entryDao;

  HomeRepositoryImpl(BuildContext context) {
    try {
      _walletDao = WalletDao(context.watch<LocalDatabase>());
      _entryDao = EntryDao(context.watch<LocalDatabase>());
    } catch(e) {
      _walletDao = WalletDao(context.read<LocalDatabase>());
      _entryDao = EntryDao(context.read<LocalDatabase>());
    }
  }

  @override
  Future<List<WalletWithBalance>> getWalletsWithBalance() async {
    return getBook().then((value) {
      return _walletDao.getWalletsWithBalance(value.id);
    });
  }

  @override
  Future<List<CashFlowOfDay>> getCashFlow(int startTime, int endTime) {
    return getBook().then((value) => _entryDao.getCashFlow(startTime, endTime, value.id));
  }

  @override
  Future<List<ExpenseOfCategory>> getTotalExpenseForAllCategories(
      int startTime, int endTime) {
    return getBook().then((value) => _entryDao.getTotalExpenseForAllCategories(startTime, endTime, value.id));
  }

  @override
  Future<List<EntryWithCategoryAndWallet>> getTopFiveEntries(
      int startTime, int endTime) {
    return getBook().then((value) {
      return _entryDao.getTopFiveEntry(startTime, endTime, value.id);
    });
  }
}