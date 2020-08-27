import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';

class CategoryWithTags {
  category mCategory;
  List<tag> tags;

  CategoryWithTags(this.mCategory, this.tags);

  List<int> checkedTagIndexes = [];
}
