class EntriesEvent {}

class GetEntriesEvent extends EntriesEvent {
  int startTime;
  int endTime;

  GetEntriesEvent(this.startTime, this.endTime);
}
