import 'package:expense_manager/ui/createentry/AddEntryEvents.dart';
import 'package:expense_manager/ui/createentry/AddEntryStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class CreateEntryBloc extends Bloc<AddEntryEvent, AddEntryState> {

  CreateEntryBloc(): super(null);
  PublishSubject<int> subject = PublishSubject();
  Stream<int> get saveButtonListener => subject.stream;

  @override
  Stream<AddEntryState> mapEventToState(AddEntryEvent event) async* {
    if(event is SaveEvent) {
      subject.sink.add(1);
      yield* Stream.value(AddEntryState());
    }
  }
}