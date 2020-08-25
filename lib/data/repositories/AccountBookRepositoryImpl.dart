import 'package:expense_manager/data/datasources/app_preference.dart';
import 'package:expense_manager/data/datasources/localdb/AccountBookDao.dart';
import 'package:expense_manager/data/datasources/localdb/CategoryDao.dart';
import 'package:expense_manager/data/datasources/localdb/EntryDao.dart';
import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/datasources/localdb/WalletDao.dart';
import 'package:expense_manager/data/models/EntryWithCategoryAndWallet.dart';
import 'package:expense_manager/data/models/account_book_with_balance.dart';
import 'package:expense_manager/data/repositories/AccountBookRepository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class AccountBookRepositoryImpl extends AccountBookRepository {
  AccountBookRepositoryImpl(this.context) {
    _accountBookDao = AccountBookDao(context.read<LocalDatabase>());
    _categoryDao = CategoryDao(context.read<LocalDatabase>());
    _walletDao = WalletDao(context.read<LocalDatabase>());
    _entryDao = EntryDao(context.read<LocalDatabase>());
  }

  final BuildContext context;
  AccountBookDao _accountBookDao;
  CategoryDao _categoryDao;
  WalletDao _walletDao;
  EntryDao _entryDao;
  AppPreference _preference = AppPreference();

  @override
  Future<List<AccountBookWithBalance>> getAllAccountBooks() {
    return _accountBookDao.getAllAccountBooks();
  }

  @override
  Stream<int> createAnAccountBook(account_book book) {
    return _accountBookDao.insert(book).flatMap((value) {
      return _initializeDataForAccountBook(value);
    });
  }

  @override
  Future<int> editAnAccountBook(account_book book) {
    return _accountBookDao.editAnAccountBook(book);
  }

  @override
  Future<int> saveCurrentAccountBook(account_book book) {
    return _preference.setBook(book);
  }

  @override
  Future<void> deleteAnAccountBook(account_book book) {
    return _accountBookDao.deleteAnAccountBook(book);
  }

  @override
  Future<account_book> getCurrentBook() {
    return _preference.getBook();
  }

  @override
  Future<List<EntryWithCategoryAndWallet>> getAllEntries(int bookId) {
    return _entryDao.getAllEntries(bookId);
  }

  Stream<int> _initializeDataForAccountBook(int accountBookId) {
    List<category> categories = [
      category(
          name: "Food",
          color: 0xFF00C853,
          bookId: accountBookId,
          canDelete: false,
          isIncome: false),
      category(
          name: "Transport",
          color: 0xFF1565C0,
          bookId: accountBookId,
          canDelete: false,
          isIncome: false),
      category(
          name: "Shopping",
          color: 0xFF673AB7,
          bookId: accountBookId,
          canDelete: false,
          isIncome: false),
      category(
          name: "Bills",
          color: 0xFF004D40,
          bookId: accountBookId,
          canDelete: false,
          isIncome: false),
      category(
          name: "Gift",
          color: 0xFFD32F2F,
          bookId: accountBookId,
          canDelete: false,
          isIncome: false),
      category(
          name: "Investment",
          color: 0xFF01579B,
          bookId: accountBookId,
          canDelete: false,
          isIncome: false),
      category(
          name: "Health",
          color: 0xFFD81B60,
          bookId: accountBookId,
          canDelete: false,
          isIncome: false),
      category(
          name: "Travel",
          color: 0xFF00796B,
          bookId: accountBookId,
          canDelete: false,
          isIncome: false),
      category(
          name: "Entertainment",
          color: 0xFF5E35B1,
          bookId: accountBookId,
          canDelete: false,
          isIncome: false),
      category(
          name: "Education",
          color: 0xFF2E7D32,
          bookId: accountBookId,
          canDelete: false,
          isIncome: false),
      category(
          name: "Adjustment",
          color: 0xFFAA00FF,
          bookId: accountBookId,
          canDelete: false,
          isIncome: false),
      category(
          name: "Other",
          color: 0xFFFF6F00,
          bookId: accountBookId,
          canDelete: false,
          isIncome: false),
      category(
          name: "Salary",
          color: 0xFF81C784,
          bookId: accountBookId,
          canDelete: false,
          isIncome: true),
      category(
          name: "Gift",
          color: 0xFF1E88E5,
          bookId: accountBookId,
          canDelete: true,
          isIncome: true),
      category(
          name: "Adjustment",
          color: 0xFFAA00FF,
          bookId: accountBookId,
          canDelete: true,
          isIncome: true),
      category(
          name: "Other",
          color: 0xFFFF6F00,
          bookId: accountBookId,
          canDelete: false,
          isIncome: true),
    ];
    List<Stream> streams = [];
    categories.forEach((element) {
      streams.add(_categoryDao.insertCategory(element).flatMap((categoryId) {
        List<tag> tags = [];
        switch (element.name) {
          case "Food":
            {
              tags.add(tag(
                  name: "Fruits",
                  color: 0xFFFF6F00,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
              tags.add(tag(
                  name: "Vegetables",
                  color: 0xFF558B2F,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
            }
            break;

          case "Transport":
            {
              tags.add(tag(
                  name: "Taxi",
                  color: 0xFFFF6F00,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
              tags.add(tag(
                  name: "Public Transport",
                  color: 0xFFE65100,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
            }
            break;

          case "Shopping":
            {
              tags.add(tag(
                  name: "Clothing",
                  color: 0xFF00796B,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
              tags.add(tag(
                  name: "Groceries",
                  color: 0xFFE65100,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
              tags.add(tag(
                  name: "Accessories",
                  color: 0xFF558B2F,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
              tags.add(tag(
                  name: "Footware",
                  color: 0xFF283593,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
              tags.add(tag(
                  name: "Electronics",
                  color: 0xFF424242,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
              tags.add(tag(
                  name: "Crockery",
                  color: 0xFF424242,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
            }
            break;

          case "Bills":
            {
              tags.add(tag(
                  name: "Electricity",
                  color: 0xFF455A64,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
              tags.add(tag(
                  name: "Water",
                  color: 0xFF303F9F,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
              tags.add(tag(
                  name: "Phone",
                  color: 0xFF558B2F,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
              tags.add(tag(
                  name: "Home Rent",
                  color: 0xFF616161,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
              tags.add(tag(
                  name: "House maid",
                  color: 0xFF4E342E,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
              tags.add(tag(
                  name: "Internet",
                  color: 0xFF8E24AA,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
              tags.add(tag(
                  name: "Cable TV",
                  color: 0xFF0097A7,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
            }
            break;

          case "Gift":
            {
              tags.add(tag(
                  name: "Charity",
                  color: 0xFF00838F,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
            }
            break;

          case "Health":
            {
              tags.add(tag(
                  name: "Doctor",
                  color: 0xFF00838F,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
              tags.add(tag(
                  name: "Medicine",
                  color: 0xFFFF6F00,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
              tags.add(tag(
                  name: "Medical Test",
                  color: 0xFFD81B60,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
            }
            break;

          case "Entertainment":
            {
              tags.add(tag(
                  name: "Games",
                  color: 0xFF5E35B1,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
              tags.add(tag(
                  name: "Movie",
                  color: 0xFFD32F2F,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
              ;
            }
            break;

          case "Education":
            {
              tags.add(tag(
                  name: "Book",
                  color: 0xFFD81B60,
                  bookId: accountBookId,
                  canDelete: false,
                  categoryId: categoryId));
            }
        }
        if (!element.isIncome) {
          tags.add(tag(
              name: "Other",
              color: 0xFFFF6F00,
              bookId: accountBookId,
              canDelete: false,
              categoryId: categoryId));
        } else {
          tags.clear();
        }
        return _categoryDao.insertTags(tags);
      }));
    });
    wallet mWallet = wallet(
        name: "Cash",
        color: 0xFFFF6F00,
        bookId: accountBookId,
        canDelete: false);
    streams.add(_walletDao.insertWallet(mWallet).asStream());
    return ZipStream(streams, (values) => values.length);
  }
}
