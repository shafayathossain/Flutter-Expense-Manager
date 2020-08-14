import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/CashFlowOfDay.dart';
import 'package:expense_manager/data/models/EntryWithCategoryAndWallet.dart';
import 'package:expense_manager/data/models/ExpenseOfCategory.dart';
import 'package:expense_manager/data/models/WalletWithBalance.dart';

abstract class HomeRepository {

  Future<List<WalletWithBalance>> getWalletsWithBalance();
  Future<List<CashFlowOfDay>> getCashFlow(int startTime, int endTime);
  Future<List<ExpenseOfCategory>> getTotalExpenseForAllCategories(int startTime, int endTime);
  Future<List<EntryWithCategoryAndWallet>> getTopFiveEntries(int startTime, int endTime);
  Future<account_book> getCurrentAccountBook();
  Future<int> clearCurrentAccountBook();
}