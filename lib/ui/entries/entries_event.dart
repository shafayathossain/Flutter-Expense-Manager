import 'package:expense_manager/data/models/EntryWithCategoryAndWallet.dart';

class EntriesEvent {}

class GetEntriesEvent extends EntriesEvent {
  int startTime;
  int endTime;

  GetEntriesEvent(this.startTime, this.endTime);
}

class DeleteEntryEvent extends EntriesEvent {
  EntryWithCategoryAndWallet entry;

  DeleteEntryEvent(this.entry);
}

class SearchEntryEvent extends EntriesEvent {
  String keyword;
  List<EntryWithCategoryAndWallet> entries;

  SearchEntryEvent(this.keyword, this.entries);
}

class GetWalletsAndCategoriesEvent extends EntriesEvent {}

class FilterEvent extends EntriesEvent {
  List<int> walletIds;
  List<int> categoryIds;
  List<int> tagIds;

  FilterEvent(this.walletIds, this.categoryIds, this.tagIds);
}
