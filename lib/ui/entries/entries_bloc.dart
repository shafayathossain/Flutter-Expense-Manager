import 'package:expense_manager/data/models/EntryWithCategoryAndWallet.dart';
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
}
