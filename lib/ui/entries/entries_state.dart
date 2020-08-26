import 'package:expense_manager/data/models/EntryWithCategoryAndWallet.dart';
import 'package:expense_manager/data/models/entry_list_item.dart';

class EntriesState {}

class GetEntriesState extends EntriesState {
  List<EntryListItem> entries;
  List<EntryWithCategoryAndWallet> rawEntries;

  GetEntriesState(this.entries, this.rawEntries);
}
