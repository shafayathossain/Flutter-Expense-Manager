import 'package:moor_flutter/moor_flutter.dart';

@DataClassName("wallet")
class Wallet extends Table {

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get color => integer()();
  IntColumn get bookId => integer().customConstraint("REFERENCES account_book(id)")();
  BoolColumn get canDelete => boolean()();

  @override
  List<String> get customConstraints => [
    'UNIQUE (name, book_id)'
  ];

}