import 'package:expense_manager/data/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/localdb/WalletDao.dart';
import 'package:expense_manager/data/models/WalletWithBalance.dart';
import 'package:expense_manager/data/repositories/HomeRepository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class HomeRepositoryImpl extends HomeRepository {

  WalletDao _walletDao;

  HomeRepositoryImpl(BuildContext context) {
    _walletDao = WalletDao(context.read<LocalDatabase>());
  }

  @override
  Stream<List<WalletWithBalance>> getWalletsWithBalance() {
    return _walletDao.getWalletsWithBalance();
  }
}