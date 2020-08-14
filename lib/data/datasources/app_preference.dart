import 'dart:convert';

import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String BOOK = "book";

class AppPreference {

  static final AppPreference _appPreference = AppPreference._internal();
  SharedPreferences _preference;

  factory AppPreference() {
    return _appPreference;
  }

  AppPreference._internal() {
    _initPreference();
  }

  void _initPreference() async {
    _preference = await SharedPreferences.getInstance();
  }

  Future<account_book> getBook() async {
    final preference = await SharedPreferences.getInstance();
    final bookString = preference.getString(BOOK);
    if(bookString == null) {
      return null;
    }
    final Map<String, dynamic> json = jsonDecode(bookString);
    return account_book.fromJson(json);
  }

  Future<int> setBook(account_book book) async {
    try {
      final preference = await SharedPreferences.getInstance();
      if(book == null) {
        preference.remove(BOOK);
      } else {
        final bookString = book.toJsonString();
        preference.setString(BOOK, bookString);
      }
      return 1;
    } catch(e) {
      print(e);
      return 0;
    }
  }
}