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