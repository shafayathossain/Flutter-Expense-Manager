
import 'dart:async';

import 'package:expense_manager/ui/createentry/AddEntryEvents.dart';
import 'package:expense_manager/ui/createentry/AddEntryStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:rxdart/rxdart.dart';

class AddEntryBloc extends Bloc<AddEntryEvent, AddEntryState> {

  AddEntryBloc() : super(null);

  BehaviorSubject<String> amountValidator = BehaviorSubject();
  
  Stream<String> get amountFormula => amountValidator.stream.transform(validateFormula);

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
    if(event is CheckFormulaEvent) {
      yield* evaluateFormula(event.formula);
    }
  }
}

Stream<AddEntryState> evaluateFormula(String formulaString) async* {

}

