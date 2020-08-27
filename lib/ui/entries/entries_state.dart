import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/EntryWithCategoryAndWallet.dart';
import 'package:expense_manager/data/models/category_with_tags.dart';
import 'package:expense_manager/data/models/entry_list_item.dart';

class EntriesState {}

class GetEntriesState extends EntriesState {
  List<EntryListItem> entries;
  List<EntryWithCategoryAndWallet> rawEntries;

  GetEntriesState(this.entries, this.rawEntries);
}

class GetWalletsAndCategoriesState extends EntriesState {
  List<wallet> wallets;
  List<CategoryWithTags> categories;

  GetWalletsAndCategoriesState(this.wallets, this.categories);
}
