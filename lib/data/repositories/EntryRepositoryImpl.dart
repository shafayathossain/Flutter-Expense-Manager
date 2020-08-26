import 'package:expense_manager/data/datasources/app_preference.dart';
import 'package:expense_manager/data/datasources/localdb/CategoryDao.dart';
import 'package:expense_manager/data/datasources/localdb/EntryDao.dart';
import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/datasources/localdb/WalletDao.dart';
import 'package:expense_manager/data/repositories/EntryRepository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntryRepositoryImpl extends EntryRepository {
  EntryRepositoryImpl(this._context) {
    _entryDao = EntryDao(_context.read<LocalDatabase>());
    _categoryDao = CategoryDao(_context.read<LocalDatabase>());
    _walletDao = WalletDao(_context.read<LocalDatabase>());
  }

  BuildContext _context;
  EntryDao _entryDao;
  CategoryDao _categoryDao;
  WalletDao _walletDao;
  AppPreference _appPreference = AppPreference();

  @override
  Future<List<category>> getAllCategories(bool isIncome) {
    return _appPreference.getBook().then((value) {
      return _categoryDao.getCategories(isIncome, value.id);
    });
  }

  @override
  Future<int> createCategory(String name, int color) {
    return _appPreference.getBook().then((book) {
      category cat = category(
          name: name,
          color: color,
          canDelete: true,
          bookId: book.id,
          isIncome: false);
      return _categoryDao.insertCategory(cat).then((value) {
        tag mTag = tag(
            name: "Other",
            color: color,
            canDelete: false,
            bookId: book.id,
            categoryId: value);
        return _categoryDao.insertTag(mTag);
      });
    });
  }

  @override
  Stream<List<tag>> getAllTags(int categoryId) {
    return _categoryDao.getTagsForACategory(categoryId);
  }

  @override
  Future<int> createTag(String name, int color, int categoryId) {
    tag mTag = tag(
        name: name,
        color: color,
        canDelete: true,
        bookId: 1,
        categoryId: categoryId);
    return _categoryDao.insertTag(mTag);
  }

  @override
  Future<List<wallet>> getAllWallets() {
    return _appPreference.getBook().then((value) {
      return _walletDao.getWallets(value.id);
    });
  }

  @override
  Future<int> addEntry(num amount, int time, category category, wallet wallet,
      String description, tag tag, int entryId) {
    return _appPreference.getBook().then((value) {
      if (entryId != null) {
        entry mEntry = entry(
            id: entryId,
            amount: amount,
            date: time,
            bookId: value.id,
            categoryId: category.id,
            walletId: wallet.id,
            description: description,
            tagId: tag == null ? null : tag.id);
        return _entryDao.updateEntry(mEntry).then((value) {
          return Future.value(1);
        });
      } else {
        entry mEntry = entry(
            amount: amount,
            date: time,
            bookId: value.id,
            categoryId: category.id,
            walletId: wallet.id,
            description: description,
            tagId: tag == null ? null : tag.id);
        return _entryDao.insertEntry(mEntry);
      }
    });
  }
}
