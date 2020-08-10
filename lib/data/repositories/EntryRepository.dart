import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';

abstract class EntryRepository {

  Stream<List<category>> getAllCategories(bool isIncome);
  Stream<int> createCategory(String name, int color);
  Stream<List<tag>> getAllTags(int categoryId);
  Stream<int> createTag(String name, int color, int categoryId);
  Stream<List<wallet>> getAllWallets();
  Stream<int> addEntry(num amount, int time, category category, wallet wallet,
      String description, tag tag);

}