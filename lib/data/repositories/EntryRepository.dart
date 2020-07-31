import 'package:expense_manager/data/localdb/LocalDatabase.dart';

abstract class EntryRepository {

  Stream<List<category>> getAllCategories();
  Stream<int> createCategory(String name, int color);

}