import 'package:expense_manager/data/models/entry_list_item.dart';
import 'package:expense_manager/data/repositories/HomeRepository.dart';
import 'package:expense_manager/ui/entries/entries_event.dart';
import 'package:expense_manager/ui/entries/entries_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EntriesBloc extends Bloc<EntriesEvent, EntriesState> {
  final HomeRepository _repository;

  EntriesBloc(this._repository) : super(null);

  @override
  Stream<EntriesState> mapEventToState(EntriesEvent event) async* {
    if (event is GetEntriesEvent) {
      yield* _getEntries(event.startTime, event.endTime);
    }
  }

  Stream<EntriesState> _getEntries(int startTime, int endTime) async* {
    final result =
        await _repository.getEntriesBetweenADateRange(startTime, endTime);
    print(result[1].mWallet.name);
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
    yield* Stream.value(GetEntriesState(itemsToShow));
  }
}
