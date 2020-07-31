
import 'package:moor_flutter/moor_flutter.dart';

@DataClassName("account_book")
class AccountBook extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get color => integer()();
  IntColumn get creationDate => integer()();
}