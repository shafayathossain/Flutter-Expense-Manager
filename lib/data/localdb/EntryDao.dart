
import 'package:expense_manager/data/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/CashFlowOfDay.dart';
import 'package:expense_manager/data/models/Category.dart';
import 'package:expense_manager/data/models/Entry.dart';
import 'package:expense_manager/data/models/EntryWithCategoryAndWallet.dart';
import 'package:expense_manager/data/models/ExpenseOfCategory.dart';
import 'package:expense_manager/data/models/Tag.dart';
import 'package:expense_manager/data/models/Wallet.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'EntryDao.g.dart';

@UseDao(tables: [Entry, Tag, Category, Wallet])
class EntryDao extends DatabaseAccessor<LocalDatabase> with _$EntryDaoMixin {
  
  LocalDatabase _database;
  
  EntryDao(LocalDatabase database): super(database){
    this._database = database;
  }

  Stream<List<EntryWithCategoryAndWallet>> getTopFiveEntry(int startTimeInMillis, int endTimeInMillis, int bookId) {
    final query = select(_database.entry)
        .join(
        [
          leftOuterJoin(_database.wallet,
              _database.entry.walletId.equalsExp(_database.wallet.id)),
          leftOuterJoin(_database.category,
              _database.category.id.equalsExp(_database.entry.categoryId)),
          leftOuterJoin(_database.tag, _database.tag.id.equalsExp(_database.entry.tagId))
        ])..where(_database.entry.bookId.equals(bookId) & _database.entry.date.isBetweenValues(startTimeInMillis, endTimeInMillis))
      ..orderBy([OrderingTerm.desc(_database.entry.amount)])
      ..limit(5);

    return query.get().asStream().map((rows) {
      return rows.map((e) {
        return EntryWithCategoryAndWallet(
          e.readTable(this.entry as TableInfo<$EntryTable, entry>),
          e.readTable(this.category as TableInfo<$CategoryTable, category>),
          e.readTable(this.tag as TableInfo<$TagTable, tag>),
          e.readTable(this.wallet as TableInfo<$WalletTable, wallet>)
        );
      }).toList();
    });
  }

  Stream<List<EntryWithCategoryAndWallet>> getEntriesBetweenADateRange(int startTimeInMillis, int endTimeInMillis, int bookId) {
    final query = select(_database.entry)
        .join(
        [
          leftOuterJoin(_database.wallet,
              _database.entry.walletId.equalsExp(_database.wallet.id)),
          leftOuterJoin(_database.category,
              _database.category.id.equalsExp(_database.entry.categoryId)),
          leftOuterJoin(_database.tag, _database.tag.id.equalsExp(_database.entry.tagId))
        ])..where(_database.entry.bookId.equals(bookId) & _database.entry.date.isBetweenValues(startTimeInMillis, endTimeInMillis))
      ..orderBy([OrderingTerm.desc(_database.entry.amount)]);

    return query.get().asStream().map((rows) {
      return rows.map((e) {
        return EntryWithCategoryAndWallet(
            e.readTable(this.entry as TableInfo<$EntryTable, entry>),
            e.readTable(this.category as TableInfo<$CategoryTable, category>),
            e.readTable(this.tag as TableInfo<$TagTable, tag>),
            e.readTable(this.wallet as TableInfo<$WalletTable, wallet>)
        );
      }).toList();
    });
  }

  Stream<List<EntryWithCategoryAndWallet>> getAllEntries(int bookId) {
    final query = select(_database.entry)
        .join(
        [
          leftOuterJoin(_database.wallet,
              _database.entry.walletId.equalsExp(_database.wallet.id)),
          leftOuterJoin(_database.category,
              _database.category.id.equalsExp(_database.entry.categoryId)),
          leftOuterJoin(_database.tag, _database.tag.id.equalsExp(_database.entry.tagId))
        ])..where(_database.entry.bookId.equals(bookId))
      ..orderBy([OrderingTerm.desc(_database.entry.amount)]);

    return query.get().asStream().map((rows) {
      return rows.map((e) {
        return EntryWithCategoryAndWallet(
            e.readTable(this.entry as TableInfo<$EntryTable, entry>),
            e.readTable(this.category as TableInfo<$CategoryTable, category>),
            e.readTable(this.tag as TableInfo<$TagTable, tag>),
            e.readTable(this.wallet as TableInfo<$WalletTable, wallet>)
        );
      }).toList();
    });
  }

  Stream<int> insertEntry(entry entry) {
    return into(_database.entry).insert(entry).asStream();
  }

  Stream<bool> updateEntry(entry entry) {
    return update(_database.entry).replace(entry).asStream();
  }

  Stream<int> deleteEntry(entry entry) {
    return delete(_database.entry).delete(entry).asStream();
  }

  Stream<int> updateAllEntriesCategory(int categoryIdToBeReplaced, int categoryIdToReplace) {
    return (update(_database.entry)
      ..where((tbl) => tbl.categoryId.equals(categoryIdToBeReplaced))
    ).write(EntryCompanion(
      categoryId: Value(categoryIdToBeReplaced)
    )).asStream();
  }

  Stream<int> removeAllEntriesTag(int tagIdToBeRemoved) {
    return (update(_database.entry)
      ..where((tbl) => tbl.tagId.equals(tagIdToBeRemoved))
    ).write(EntryCompanion(
        categoryId: Value(null)
    )).asStream();
  }

  Stream<List<ExpenseOfCategory>> getTotalExpenseForAllCategories(int startTime, int endTime, int bookId) {

    final total = _database.entry.amount.sum();
    final name = _database.category.name;
    final color = _database.category.color;

    final query = select(_database.entry)
        .join(
        [
          leftOuterJoin(_database.wallet,
              _database.entry.walletId.equalsExp(_database.wallet.id)),
          leftOuterJoin(_database.category,
              _database.category.id.equalsExp(_database.entry.categoryId)),
          leftOuterJoin(_database.tag, _database.tag.id.equalsExp(_database.entry.tagId))
        ])
      ..addColumns([total, name, color])
      ..where(_database.entry.bookId.equals(bookId) & _database.entry.date.isBetweenValues(startTime, endTime))
      ..orderBy([OrderingTerm.desc(_database.entry.amount)]);

    return query.watch().map((event) {
      return event.map((e) {
        return ExpenseOfCategory(
          e.read(total),
          e.read(name),
          e.read(color)
        );
      }).toList();
    });
  }

  Stream<List<CashFlowOfDay>> getCashFlow(int startDate, int endDate, int bookId) {
    final income = (_database.entry.amount..isBiggerThan(CustomExpression("0"))).sum();
    final expense = (_database.entry.amount..isSmallerOrEqual(CustomExpression("0"))).sum();
    final date = _database.entry.date;

    final query = select(_database.entry)
        .join(
        [
          leftOuterJoin(_database.wallet,
              _database.entry.walletId.equalsExp(_database.wallet.id)),
          leftOuterJoin(_database.category,
              _database.category.id.equalsExp(_database.entry.categoryId)),
          leftOuterJoin(_database.tag, _database.tag.id.equalsExp(_database.entry.tagId))
        ])
      ..addColumns([income, expense, date])
      ..where(_database.entry.bookId.equals(bookId) & _database.entry.date.isBetweenValues(startDate, endDate))
      ..orderBy([OrderingTerm.desc(_database.entry.amount)]);

    return query.watch().map((event) {
      return event.map((e) {
        return CashFlowOfDay(
            e.read(income),
            e.read(expense),
            e.read(date)
        );
      }).toList();
    });

  }

  Stream<int> updateAllEntriesWallet(int walletId) {
    return (update(_database.entry)
      ..where((tbl) => tbl.categoryId.equals(1))
    ).write(EntryCompanion(
        categoryId: Value(walletId)
    )).asStream();
  }

}