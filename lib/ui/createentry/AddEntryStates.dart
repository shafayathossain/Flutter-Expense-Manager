import 'package:expense_manager/data/localdb/LocalDatabase.dart';

class AddEntryState {}

class FormulaValueState extends AddEntryState {
  String result;
}

class FormulaErrorState extends AddEntryState {}

class CategoriesFetchedState extends AddEntryState {
  CategoriesFetchedState(this.categories);
  List<category> categories = [];
}

class TagsFetchedState extends AddEntryState {
  TagsFetchedState(this.tags);
  List<tag> tags = [];
}

class WalletsFetchedState extends AddEntryState {
  WalletsFetchedState(this.wallets);
  List<wallet> wallets = [];
}