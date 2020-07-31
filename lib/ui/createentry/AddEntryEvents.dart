
class AddEntryEvent {}

class CheckFormulaEvent extends AddEntryEvent {
  String formula;
  CheckFormulaEvent({this.formula});
}

class GetCategoriesEvent extends AddEntryEvent {}

class CreateCategoryEvent extends AddEntryEvent {
  CreateCategoryEvent(this.name, this.color);
  String name;
  int color;
}