import 'package:expense_manager/data/models/Category.dart';
import 'package:expense_manager/data/models/Tag.dart';

class CategoryWithTag {
  CategoryWithTag(this.category, this.tag);
  Category category;
  Tag tag;
}