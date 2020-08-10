import 'package:expense_manager/data/datasources/localdb/CategoryDao.dart';
import 'package:expense_manager/data/datasources/localdb/EntryDao.dart';
import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/datasources/localdb/WalletDao.dart';
import 'package:expense_manager/data/repositories/EntryRepository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

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

  @override
  Stream<List<category>> getAllCategories(bool isIncome) {
    return _categoryDao.getCategories(isIncome, 0);
  }

  @override
  Stream<int> createCategory(String name, int color) {
    category cat = category(
      name: name,
      color: color,
      canDelete: true,
      bookId: 1,
      isIncome: false
    );
    return _categoryDao.insertCategory(cat)
        .flatMap((value) {
          tag mTag = tag(
            name: name,
            color: color,
            canDelete: true,
            bookId: 1,
            categoryId: value
          );
          return _categoryDao.insertTag(mTag);
        });
  }

  @override
  Stream<List<tag>> getAllTags(int categoryId) {
    return _categoryDao.getTagsForACategory(categoryId);
  }

  @override
  Stream<int> createTag(String name, int color, int categoryId) {
    tag mTag = tag(
        name: name,
        color: color,
        canDelete: true,
        bookId: 1,
        categoryId: categoryId
    );
    return _categoryDao.insertTag(mTag);
  }

  @override
  Stream<List<wallet>> getAllWallets() {
    return _walletDao.getWallets(0);
  }

  @override
  Stream<int> addEntry(num amount, int time, category category, wallet wallet,
      String description, tag tag) {
    entry mEntry = entry(
      amount: amount,
      date: time,
      bookId: 1,
      categoryId: category.id,
      walletId: wallet.id,
      description: description,
      tagId: tag == null ? null : tag.id
    );
    return _entryDao.insertEntry(mEntry);
  }
}