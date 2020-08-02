
class AddEntryEvent {}

class SaveEvent extends AddEntryEvent {}

class CheckFormulaEvent extends AddEntryEvent {
  String formula;
  CheckFormulaEvent({this.formula});
}

class GetCategoriesEvent extends AddEntryEvent {
  bool isIncome;
  GetCategoriesEvent(this.isIncome);
}

class GetWalletsEvent extends AddEntryEvent {}

class CreateCategoryEvent extends AddEntryEvent {
  CreateCategoryEvent(this.name, this.color, this.isIncome);
  String name;
  int color;
  bool isIncome;
}

class GetTagsEvent extends AddEntryEvent {
  GetTagsEvent(this.categoryId);
  int categoryId;
}

class CreateTagEvent extends AddEntryEvent {
  CreateTagEvent(this.name, this.color, this.categoryId);
  String name;
  int color;
  int categoryId;
}