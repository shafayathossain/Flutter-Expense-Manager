class AddEntryState {}

class FormulaValueState extends AddEntryState {
  String result;
}

class FormulaErrorState extends AddEntryState {}