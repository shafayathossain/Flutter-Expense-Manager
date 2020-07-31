import 'package:moor_flutter/moor_flutter.dart';

@DataClassName("entry")
class Entry extends Table {

  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  IntColumn get date => integer()();
  IntColumn get categoryId => integer().customConstraint("REFERENCES category(id)")();
  IntColumn get tagId => integer().nullable().customConstraint("NULLABLE REFERENCES tag(id)")();
  IntColumn get walletId => integer().customConstraint("REFERENCES wallet(id)")();
  TextColumn get description => text().nullable()();
  IntColumn get bookId => integer().customConstraint("REFERENCES account_book(id)")();

}