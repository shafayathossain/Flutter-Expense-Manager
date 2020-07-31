
import 'dart:async';

import 'package:expense_manager/data/repositories/EntryRepository.dart';
import 'package:expense_manager/ui/createentry/AddEntryEvents.dart';
import 'package:expense_manager/ui/createentry/AddEntryStates.dart';
import 'package:expense_manager/data/localdb/LocalDatabase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:rxdart/rxdart.dart';

class AddEntryBloc extends Bloc<AddEntryEvent, AddEntryState> {

  AddEntryBloc(this._repository) : super(null);

  EntryRepository _repository;
  BehaviorSubject<String> amountValidator = BehaviorSubject();
  BehaviorSubject<List<category>> categorySubject = BehaviorSubject();
  Stream<String> get amountFormula => amountValidator.stream.transform(validateFormula);
  Stream<List<category>> get categories => categorySubject.stream;

  final validateFormula =
  StreamTransformer<String, String>.fromHandlers(handleData: (formulaString, sink) {
    Parser parser = Parser();
    Expression exp = parser.parse(formulaString);
    try {
      double value = exp.evaluate(EvaluationType.REAL, ContextModel());
      print(value);
      return sink.add(value.toString());
    } catch(e) {
      print(e.toString());
      sink.addError(e.toString());
    }
  });

  @override
  Stream<AddEntryState> mapEventToState(AddEntryEvent event) async* {
    if(event is GetCategoriesEvent) {
      yield* getCategories().map((event) => CategoriesFetchedState(event));
    } else if(event is CreateCategoryEvent) {
      yield* createCategory(event.name, event.color);
    }
  }

  Stream<List<category>> getCategories() async* {
    yield* _repository.getAllCategories().doOnData((event) {categorySubject.sink.add(event);});
  }

  Stream<AddEntryState> createCategory(String name, int color) async* {
    yield* _repository.createCategory(name, color)
        .flatMap((value) {
          return getCategories();
        })
        .map((event) {
          print("ADD ENTRY 54 -> ${event}");
          categorySubject.sink.add(event);
          return CategoriesFetchedState(event);
        });
  }
}


