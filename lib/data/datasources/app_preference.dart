import 'dart:convert';

import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String BOOK = "book";

Future<account_book> getBook() async {
  final preference = await SharedPreferences.getInstance();
  final bookString = preference.getString(BOOK);
  final Map<String, dynamic> json = jsonDecode(bookString);
  return account_book.fromJson(json);
}

Future<int> setBook(account_book book) async {
  try {
    final preference = await SharedPreferences.getInstance();
    final bookString = book.toString();
    preference.setString(BOOK, bookString);
    return 1;
  } catch(e) {
    return 0;
  }
}