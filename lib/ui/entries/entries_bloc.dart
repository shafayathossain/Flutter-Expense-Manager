import 'package:expense_manager/data/models/EntryWithCategoryAndWallet.dart';
import 'package:expense_manager/data/models/category_with_tags.dart';
import 'package:expense_manager/data/models/entry_list_item.dart';
import 'package:expense_manager/data/repositories/HomeRepository.dart';
import 'package:expense_manager/ui/entries/entries_event.dart';
import 'package:expense_manager/ui/entries/entries_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EntriesBloc extends Bloc<EntriesEvent, EntriesState> {
  final HomeRepository _repository;
  int _lastStartTime;
  int _lastEndTime;

  EntriesBloc(this._repository) : super(null);

  @override
  Stream<EntriesState> mapEventToState(EntriesEvent event) async* {
    if (event is GetEntriesEvent) {
      yield* _getEntries(event.startTime, event.endTime);
    } else if (event is DeleteEntryEvent) {
      yield* _deleteEntry(event.entry);
    } else if (event is SearchEntryEvent) {
      yield* _search(event.keyword, event.entries);
    } else if (event is GetWalletsAndCategoriesEvent) {
      yield* _getWalletsAndCategories();
    } else if (event is FilterEvent) {
      yield* _filter(event.walletIds, event.categoryIds, event.tagIds);
    }
  }

  Stream<EntriesState> _getEntries(int startTime, int endTime) async* {
    this._lastStartTime = startTime;
    this._lastEndTime = endTime;
    final result = await _repository
        .getEntriesBetweenADateRange(startTime, endTime)
        .timeout(Duration(seconds: 5));
    List<EntryListItem> itemsToShow = [];
    final dateTimeFormatter = DateFormat("dd-MM-yyyy");
    String lastDate = "";
    result.forEach((element) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(element.mEntry.date);
      String timeString = dateTimeFormatter.format(time);
      if (lastDate != timeString) {
        lastDate = timeString;
        itemsToShow.add(EntryListItem(1, date: timeString));
      }
      itemsToShow.add(EntryListItem(2, item: element));
    });
    yield* Stream.value(GetEntriesState(itemsToShow, result));
  }

  Stream<EntriesState> _deleteEntry(EntryWithCategoryAndWallet entry) async* {
    final result = _repository.deleteEntry(entry.mEntry);
    yield* _getEntries(this._lastStartTime, this._lastEndTime);
  }

  Stream<EntriesState> _search(
      String keyword, List<EntryWithCategoryAndWallet> entries) async* {
    List<EntryListItem> itemsToShow = [];
    final dateTimeFormatter = DateFormat("dd-MM-yyyy");
    String lastDate = "";
    entries.forEach((element) {
      if (element.mEntry.description
          .toLowerCase()
          .contains(keyword.toLowerCase())) {
        DateTime time =
            DateTime.fromMillisecondsSinceEpoch(element.mEntry.date);
        String timeString = dateTimeFormatter.format(time);
        if (lastDate != timeString) {
          lastDate = timeString;
          itemsToShow.add(EntryListItem(1, date: timeString));
        }
        itemsToShow.add(EntryListItem(2, item: element));
      }
    });
    yield* Stream.value(GetEntriesState(itemsToShow, entries));
  }

  Stream<EntriesState> _getWalletsAndCategories() async* {
    final wallets = await _repository.getWallets();
    final categoriesAndTags = await _repository.getCategoriesWithTags();
    int lastCategoryId = 0;
    List<CategoryWithTags> categories = [];
    CategoryWithTags category;
    categoriesAndTags.forEach((element) {
      print(element.mTag.name);
      if (element.mCategory.id != lastCategoryId) {
        lastCategoryId = element.mCategory.id;
        if (category != null) {
          categories.add(category);
          category = new CategoryWithTags(element.mCategory, [element.mTag]);
        } else {
          category = new CategoryWithTags(element.mCategory, [element.mTag]);
        }
      } else {
        category.tags.add(element.mTag);
      }
    });
    if (category != null) {
      categories.add(category);
    }
    yield* Stream.value(GetWalletsAndCategoriesState(wallets, categories));
  }

  Stream<EntriesState> _filter(
      List<int> walletIds, List<int> categoryIds, List<int> tagIds) async* {
    this._lastStartTime = this._lastStartTime;
    this._lastEndTime = this._lastEndTime;
    final result = await _repository
        .getEntriesBetweenADateRange(this._lastStartTime, this._lastEndTime,
            walletIds: walletIds, categoryIds: categoryIds, tagIds: tagIds)
        .timeout(Duration(seconds: 5));
    List<EntryListItem> itemsToShow = [];
    final dateTimeFormatter = DateFormat("dd-MM-yyyy");
    String lastDate = "";
    print(result.length);
    result.forEach((element) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(element.mEntry.date);
      String timeString = dateTimeFormatter.format(time);
      if (lastDate != timeString) {
        lastDate = timeString;
        itemsToShow.add(EntryListItem(1, date: timeString));
      }
      itemsToShow.add(EntryListItem(2, item: element));
    });
    yield* Stream.value(GetEntriesState(itemsToShow, result));
  }
}
