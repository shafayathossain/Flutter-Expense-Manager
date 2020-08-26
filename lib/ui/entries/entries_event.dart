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
