import 'package:moor_flutter/moor_flutter.dart';

@DataClassName("category")
class Category extends Table {

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get color => integer()();
  BoolColumn get isIncome => boolean().withDefault(const Constant(false))();
  IntColumn get bookId => integer().customConstraint("REFERENCES account_book(id)")();
  BoolColumn get canDelete => boolean().withDefault(const Constant(false))();

  @override
  List<String> get customConstraints => [
    'UNIQUE (name, is_income, book_id)'
  ];
}