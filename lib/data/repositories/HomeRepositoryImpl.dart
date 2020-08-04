import 'package:expense_manager/data/localdb/EntryDao.dart';
import 'package:expense_manager/data/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/localdb/WalletDao.dart';
import 'package:expense_manager/data/models/CashFlowOfDay.dart';
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
  Stream<List<WalletWithBalance>> getWalletsWithBalance() {
    return _walletDao.getWalletsWithBalance();
  }

  @override
  Stream<List<CashFlowOfDay>> getCashFlow(int startTime, int endTime) {
    return _entryDao.getCashFlow(startTime, endTime, 1);
  }
}