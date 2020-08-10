
import 'dart:async';

import 'package:expense_manager/data/datasources/localdb/AccountBookDao.dart';
import 'package:expense_manager/data/repositories/EntryRepository.dart';
import 'package:expense_manager/ui/createentry/AddEntryEvents.dart';
import 'package:expense_manager/ui/createentry/AddEntryStates.dart';
import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:rxdart/rxdart.dart';

class AddEntryBloc extends Bloc<AddEntryEvent, AddEntryState> {

  AddEntryBloc(this._repository) : super(null);

  EntryRepository _repository;
  BehaviorSubject<String> amountValidator = BehaviorSubject();
  BehaviorSubject<List<category>> categorySubject = BehaviorSubject();
  BehaviorSubject<List<tag>> tagSubject = BehaviorSubject();
  BehaviorSubject<List<wallet>> walletSubject = BehaviorSubject();
  PublishSubject<String> errorSubject = PublishSubject();
  Stream<String> get amountFormula => amountValidator.stream.transform(validateFormula);
  Stream<List<category>> get categories => categorySubject.stream;
  Stream<List<tag>> get tags => tagSubject.stream;
  Stream<List<wallet>> get wallets => walletSubject.stream;
  Stream<String> get error => errorSubject.stream;

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
      yield* getCategories(event.isIncome).map((event) => CategoriesFetchedState(event));
    } else if(event is CreateCategoryEvent) {
      yield* createCategory(event.name, event.color, event.isIncome);
    } else if(event is GetTagsEvent) {
      yield* getTags(event.categoryId).map((event) => TagsFetchedState(event));
    } else if(event is CreateTagEvent) {
      yield* createTag(event.name, event.color, event.categoryId);
    } else if(event is GetWalletsEvent) {
      yield* getWallets().map((event) => WalletsFetchedState(event));
    } else if(event is SaveEvent) {
      yield* saveEntry(event.amountString, event.date, event.selectedCategory,
          event.selectedWallet, event.selectedTag, event.description,
          event.isIncome).map((event) {
            if(event is EntryErrorState) {
              errorSubject.add(event.error);
            }
            return event;
      });
    }
  }

  Stream<List<category>> getCategories(bool isIncome) async* {
    yield* _repository.getAllCategories(isIncome).doOnData((event) {categorySubject.sink.add(event);});
  }

  Stream<AddEntryState> createCategory(String name, int color, bool isIncome) async* {
    yield* _repository.createCategory(name, color)
        .flatMap((value) {
          return getCategories(isIncome);
        })
        .map((event) {
          print("ADD ENTRY 54 -> ${event}");
          categorySubject.sink.add(event);
          return CategoriesFetchedState(event);
        });
  }

  Stream<List<tag>> getTags(int categoryId) async* {
    yield* _repository.getAllTags(categoryId).doOnData((event) {tagSubject.sink.add(event);});
  }

  Stream<AddEntryState> createTag(String name, int color, int categoryId) async* {
    yield* _repository.createTag(name, color, categoryId)
        .flatMap((value) {
          return getTags(categoryId);
        })
        .map((event) {
          tagSubject.sink.add(event);
          return TagsFetchedState(event);
        });
  }

  Stream<List<wallet>> getWallets() async* {
    yield* _repository.getAllWallets().doOnData((event) {walletSubject.sink.add(event);});
  }

  Stream<AddEntryState> saveEntry(String amountString, String date,
      category selectedCategory, wallet selectedWallet, tag selectedTag,
      String description, bool isIncome) async* {

    Parser parser = Parser();
    double value;
    bool hasError = false;
    try {
      Expression exp = parser.parse(amountString);
      value = exp.evaluate(EvaluationType.REAL, ContextModel());
    } catch(e) {
      hasError = true;
      yield* Stream.value(EntryErrorState("Enter a valid amount"));
    }
    int time;
    if(!hasError) {
      final formatter = DateFormat("dd-MM-yyyy");
      try {
         time = formatter
            .parse(date)
            .millisecondsSinceEpoch;
        print(time);
      } catch (e) {
        hasError = true;
        yield* Stream.value(EntryErrorState("Select a date"));
      }
    }
    if(selectedCategory == null && !hasError) {
      hasError = true;
      yield* Stream.value(EntryErrorState("Select a category"));
    } else if(selectedWallet == null && !hasError) {
      hasError = true;
      yield* Stream.value(EntryErrorState("Select a wallet"));
    } else {
      value = isIncome ? value.abs() : -1 * value.abs();
      yield* _repository
          .addEntry(value, time, selectedCategory, selectedWallet, description,
          selectedTag)
          .map((event) => EntrySavedState());
    }

  }
}


