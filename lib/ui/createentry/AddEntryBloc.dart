import 'dart:async';

import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/repositories/EntryRepository.dart';
import 'package:expense_manager/ui/createentry/AddEntryEvents.dart';
import 'package:expense_manager/ui/createentry/AddEntryStates.dart';
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
  Stream<String> get amountFormula =>
      amountValidator.stream.transform(validateFormula);
  Stream<List<category>> get categories => categorySubject.stream;
  Stream<List<tag>> get tags => tagSubject.stream;
  Stream<List<wallet>> get wallets => walletSubject.stream;
  Stream<String> get error => errorSubject.stream;

  final validateFormula = StreamTransformer<String, String>.fromHandlers(
      handleData: (formulaString, sink) {
    Parser parser = Parser();
    Expression exp = parser.parse(formulaString);
    try {
      double value = exp.evaluate(EvaluationType.REAL, ContextModel());
      return sink.add(value.toString());
    } catch (e) {
      sink.addError(e.toString());
    }
  });

  @override
  Stream<AddEntryState> mapEventToState(AddEntryEvent event) async* {
    if (event is GetCategoriesEvent) {
      yield* getCategories(event.isIncome)
          .map((event) => CategoriesFetchedState(event));
    } else if (event is CreateCategoryEvent) {
      yield* createCategory(event.name, event.color, event.isIncome);
    } else if (event is GetTagsEvent) {
      yield* getTags(event.categoryId).map((event) => TagsFetchedState(event));
    } else if (event is CreateTagEvent) {
      yield* createTag(event.name, event.color, event.categoryId);
    } else if (event is GetWalletsEvent) {
      yield* getWallets().map((event) => WalletsFetchedState(event));
    } else if (event is SaveEvent) {
      yield* saveEntry(
              event.amountString,
              event.date,
              event.selectedCategory,
              event.selectedWallet,
              event.selectedTag,
              event.description,
              event.isIncome,
              event.entryId)
          .map((event) {
        if (event is EntryErrorState) {
          errorSubject.add(event.error);
        }

        return event;
      });
    } else if (event is DeleteCategoryEvent) {
      yield* _deleteCategory(event.mCategory);
    } else if (event is DeleteTagEvent) {
      yield* _deleteTag(event.mTag);
    }
  }

  Stream<List<category>> getCategories(bool isIncome) async* {
    final result = await _repository.getAllCategories(isIncome);
    categorySubject.sink.add(result);
    yield* Stream.value(result);
  }

  Stream<AddEntryState> createCategory(
      String name, int color, bool isIncome) async* {
    final result = await _repository.createCategory(name, color);
    yield* getCategories(isIncome).map((event) {
      categorySubject.sink.add(event);
      return CategoriesFetchedState(event);
    });
  }

  Stream<List<tag>> getTags(int categoryId) async* {
    yield* _repository.getAllTags(categoryId).doOnData((event) {
      tagSubject.sink.add(event);
    });
  }

  Stream<AddEntryState> createTag(
      String name, int color, int categoryId) async* {
    final result = _repository.createTag(name, color, categoryId);
    yield* getTags(categoryId).map((event) {
      tagSubject.sink.add(event);
      return TagsFetchedState(event);
    });
  }

  Stream<List<wallet>> getWallets() async* {
    final event = await _repository.getAllWallets();
    walletSubject.sink.add(event);
    yield* Stream.value(event);
  }

  Stream<AddEntryState> saveEntry(
      String amountString,
      String date,
      category selectedCategory,
      wallet selectedWallet,
      tag selectedTag,
      String description,
      bool isIncome,
      int entryId) async* {
    Parser parser = Parser();
    double value;
    bool hasError = false;
    try {
      Expression exp = parser.parse(amountString);
      value = exp.evaluate(EvaluationType.REAL, ContextModel());
    } catch (e) {
      hasError = true;
      yield* Stream.value(EntryErrorState("Enter a valid amount"));
    }
    int time;
    if (!hasError) {
      final formatter = DateFormat("dd-MM-yyyy");
      try {
        time = formatter.parse(date).millisecondsSinceEpoch;
      } catch (e) {
        hasError = true;
        yield* Stream.value(EntryErrorState("Select a date"));
      }
    }
    if (selectedCategory == null && !hasError) {
      hasError = true;
      yield* Stream.value(EntryErrorState("Select a category"));
    } else if (selectedWallet == null && !hasError) {
      hasError = true;
      yield* Stream.value(EntryErrorState("Select a wallet"));
    } else {
      value = isIncome ? value.abs() : -1 * value.abs();
      final result = await _repository.addEntry(value, time, selectedCategory,
          selectedWallet, description, selectedTag, entryId);
      yield* Stream.value(EntrySavedState());
    }
  }

  Stream<AddEntryState> _deleteCategory(category mCategory) async* {
    final result = await _repository.deleteCategory(mCategory);
    yield* getCategories(mCategory.isIncome)
        .map((event) => CategoriesFetchedState(event));
  }

  Stream<AddEntryState> _deleteTag(tag mTag) async* {
    final result = await _repository.deleteTag(mTag);
    yield* getTags(mTag.categoryId).map((event) => TagsFetchedState(event));
  }
}
