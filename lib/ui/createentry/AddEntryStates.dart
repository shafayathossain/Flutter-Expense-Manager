import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';

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

class EntrySavedState extends AddEntryState {}

class EntryErrorState extends AddEntryState {
  String error;
  EntryErrorState(this.error);
}