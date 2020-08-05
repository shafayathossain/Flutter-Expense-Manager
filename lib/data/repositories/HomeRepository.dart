import 'package:expense_manager/data/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/CashFlowOfDay.dart';
import 'package:expense_manager/data/models/ExpenseOfCategory.dart';
import 'package:expense_manager/data/models/WalletWithBalance.dart';

abstract class HomeRepository {

  Stream<List<WalletWithBalance>> getWalletsWithBalance();
  Future<List<CashFlowOfDay>> getCashFlow(int startTime, int endTime);
  Future<List<ExpenseOfCategory>> getTotalExpenseForAllCategories(int startTime, int endTime);
}