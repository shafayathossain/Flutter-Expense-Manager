import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';

abstract class EntryRepository {
  Future<List<category>> getAllCategories(bool isIncome);
  Future<int> createCategory(String name, int color);
  Stream<List<tag>> getAllTags(int categoryId);
  Future<int> createTag(String name, int color, int categoryId);
  Future<List<wallet>> getAllWallets();
  Future<int> addEntry(num amount, int time, category category, wallet wallet,
      String description, tag tag, int entryId);
}
