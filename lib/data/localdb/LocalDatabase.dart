import 'package:expense_manager/data/localdb/AccountBookDao.dart';
import 'package:expense_manager/data/localdb/CategoryDao.dart';
import 'package:expense_manager/data/localdb/EntryDao.dart';
import 'package:expense_manager/data/models/AccountBook.dart';
import 'package:expense_manager/data/models/Category.dart';
import 'package:expense_manager/data/models/CategoryWithTag.dart';
import 'package:expense_manager/data/models/Entry.dart';
import 'package:expense_manager/data/models/Tag.dart';
import 'package:expense_manager/data/models/Wallet.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'LocalDatabase.g.dart';

@UseMoor(
  tables: [AccountBook, Category, Entry, Tag, Wallet],
  daos: [AccountBookDao, ParentCategoryDao, CategoryDao, EntryDao]
)
class LocalDatabase extends _$LocalDatabase {

  LocalDatabase() : super(FlutterQueryExecutor.inDatabaseFolder(path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;

//  static Stream<Database> getInstance() {
//    if(_db == null) {
//      _db = openDatabase(
//          "expnsmngr.db",
//        version: 1,
//        onCreate: _onCreate
//      );
//    }
//    return _db.asStream();
//  }
//
//  static void _onCreate(Database db, int version) {
//    db.execute("CREATE TABLE books(id INTEGER PRIMARY KEY NOT NULL AUTOINCREMENT, " +
//        "name TEXT NOT NULL, color INTEGER NOT NULL, " +
//        "creation_date INTEGER NOT NULL)");
//    db.execute("CREATE TABLE wallet(id INTEGER PRIMARY KEY NOT NULL AUTOINCREMENT, " +
//        "name TEXT NOT NULL, color INTEGER NOT NULL, " +
//        "book_id INTEGER NOT NULL, can_delete INTEGER NOT NULL, " +
//        "UNIQUE(name, book_id))");
//    db.execute("CREATE TABLE tag(id INTEGER PRIMARY KEY NOT NULL AUTOINCREMENT, " +
//        "name TEXT NOT NULL, color INTEGER NOT NULL, category_id INTEGER NOT NULL, " +
//        "book_id INTEGER NOT NULL, can_delete INTEGER NOT NULL )");
//    db.execute("CREATE TABLE category(id INTEGER PRIMARY KEY NOT NULL AUTOINCREMENT, " +
//        "name TEXT NOT NULL, color INTEGER NOT NULL, is_income INTEGER NOT NULL, " +
//        "book_id INTEGER NOT NULL, can_delete INTEGER NOT NULL, " +
//        "UNIQUE(name, is_income, book_id))");
//    db.execute("CREATE TABLE entry(id INTEGER PRIMARY KEY NOT NULL AUTOINCREMENT, " +
//        "amount REAL NOT NULL, date INTEGER NOT NULL, category_id INTEGER NOT NULL, " +
//        "tag_id INTEGER DEFAULT NULL, wallet_id INTEGER NOT NULL, " +
//            "description TEXT DEFAULT NULL, book_id INTEGER NOT NULL)");
//  }

}

@UseDao(tables: [category, tag])
class ParentCategoryDao extends DatabaseAccessor<LocalDatabase> {
  ParentCategoryDao(LocalDatabase database): super(database);
}