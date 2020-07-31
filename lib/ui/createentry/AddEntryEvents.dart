
class AddEntryEvent {}

class CheckFormulaEvent extends AddEntryEvent {
  String formula;
  CheckFormulaEvent({this.formula});
}