import 'package:expense_manager/data/datasources/app_preference.dart';
import 'package:expense_manager/data/datasources/localdb/CategoryDao.dart';
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

class HomeRepositoryImpl extends HomeRepository {
  WalletDao _walletDao;
  EntryDao _entryDao;
  CategoryDao _categoryDao;
  AppPreference _preference = AppPreference();

  HomeRepositoryImpl(BuildContext context) {
    try {
      _walletDao = WalletDao(context.watch<LocalDatabase>());
      _entryDao = EntryDao(context.watch<LocalDatabase>());
      _categoryDao = CategoryDao(context.watch<LocalDatabase>());
    } catch (e) {
      _walletDao = WalletDao(context.read<LocalDatabase>());
      _entryDao = EntryDao(context.read<LocalDatabase>());
      _categoryDao = CategoryDao(context.read<LocalDatabase>());
    }
  }

  @override
  Future<List<WalletWithBalance>> getWalletsWithBalance() async {
    return _preference.getBook().then((value) {
      return _walletDao.getWalletsWithBalance(value.id);
    });
  }

  @override
  Future<List<CashFlowOfDay>> getCashFlow(int startTime, int endTime) {
    return _preference
        .getBook()
        .then((value) => _entryDao.getCashFlow(startTime, endTime, value.id));
  }

  @override
  Future<List<ExpenseOfCategory>> getTotalExpenseForAllCategories(
      int startTime, int endTime) {
    return _preference.getBook().then((value) => _entryDao
        .getTotalExpenseForAllCategories(startTime, endTime, value.id));
  }

  @override
  Future<List<EntryWithCategoryAndWallet>> getTopFiveEntries(
      int startTime, int endTime) {
    return _preference.getBook().then((value) {
      return _entryDao.getTopFiveEntry(startTime, endTime, value.id);
    });
  }

  @override
  Future<account_book> getCurrentAccountBook() {
    return _preference.getBook();
  }

  @override
  Future<int> clearCurrentAccountBook() {
    return _preference.setBook(null);
  }

  @override
  Future<int> adjustWalletBalance(double amount, int date, int walletId) {
    return _preference.getBook().then((book) {
      return _categoryDao
          .findCategory("Adjustment", amount < 0 ? false : true, book.id)
          .then((category) {
        entry mEntry = entry(
            amount: amount,
            date: date,
            categoryId: category.id,
            tagId: null,
            walletId: walletId,
            description: null,
            bookId: book.id);
        return _entryDao.insertEntry(mEntry);
      });
    });
  }

  @override
  Future<int> createWallet(String name, int color) {
    return _preference.getBook().then((value) {
      wallet mWallet =
          wallet(name: name, color: color, bookId: value.id, canDelete: true);
      return _walletDao.insertWallet(mWallet);
    });
  }

  @override
  Future<List<EntryWithCategoryAndWallet>> getEntriesBetweenADateRange(
      int startTime, int endTime) {
    return _preference.getBook().then((value) {
      return _entryDao.getEntriesBetweenADateRange(
          startTime, endTime, value.id);
    });
  }

  @override
  Future<int> deleteEntry(entry mEntry) {
    return _preference.getBook().then((value) {
      return _entryDao.deleteEntry(mEntry);
    });
  }
}
