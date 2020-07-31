import 'package:moor_flutter/moor_flutter.dart';

@DataClassName("tag")
class Tag extends Table {

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get color => integer()();
  IntColumn get categoryId => integer().customConstraint("REFERENCES category(id)")();
  IntColumn get bookId => integer().customConstraint("REFERENCES account_book(id)")();
  BoolColumn get canDelete => boolean().withDefault(const Constant(false))();
}