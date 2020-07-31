import 'package:expense_manager/data/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/Category.dart';
import 'package:expense_manager/data/models/CategoryWithTag.dart';
import 'package:expense_manager/data/models/Tag.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'CategoryDao.g.dart';

@UseDao(tables: [Category, Tag])
class CategoryDao extends DatabaseAccessor<LocalDatabase> with _$CategoryDaoMixin {

  LocalDatabase _database;

  CategoryDao(LocalDatabase attachedDatabase): super(attachedDatabase) {
    this._database = attachedDatabase;
  }

  Stream<List<category>> getCategories(bool isIncome, int bookId) {
    return (select(_database.category)
      ..where((tbl) => tbl.isIncome.equals(isIncome) & tbl.bookId.equals(bookId)))
        .get().asStream();
  }

  Stream<List<CategoryWithTag>> getCategoriesWithTags(bool isIncome, int bookId) {
    final query = select(_database.tag)
        .join(
          [leftOuterJoin(_database.category,
              _database.category.id.equalsExp(_database.tag.categoryId))]
        )..where(_database.tag.bookId.equals(bookId) & _database.category.isIncome.equals(isIncome));
    return query.get().asStream().map((event) {
      return event.map((e) {
        return CategoryWithTag(
          e.readTable(this.category as TableInfo<$CategoryTable, category>),
          e.readTable(tag as TableInfo<$TagTable, tag>)
        );
      }).toList();
    });
  }

  Stream<List<tag>> getTagsForACategory(int categoryId) {
    return (select(_database.tag)..where((tbl) => tbl.categoryId.equals(categoryId))).get().asStream();
  }

  Stream<int> insertTag(tag tag) {
    return into(_database.tag).insert(tag).asStream();
  }

  Stream<int> insertCategory(category category) {
    return into(_database.category).insert(category).asStream();
  }

  Stream<int> insertCategories(List<category> categories) {
    return batch((batch) {
      batch.insertAll(_database.category, categories);
    }).asStream();
  }

  Stream<int> deleteCategory(category category) {
    return delete(_database.category).delete(category).asStream();
  }

  Stream<int> deleteTag(tag tag) {
    return delete(_database.tag).delete(tag).asStream();
  }

  Stream<category> findCategory(String name, bool isIncome, int bookId) {
    return (select(_database.category)..limit(1)
      ..where((tbl) => tbl.name.equals(name) &
      tbl.isIncome.equals(isIncome) &
      tbl.bookId.equals(bookId)))
        .getSingle().asStream();
  }

  Stream<category> getCategory(int categoryId) {
    return (select(_database.category)..where((tbl) => tbl.id.equals(categoryId))).getSingle().asStream();
  }

  Stream<tag> getATag(int tagId) {
    return (select(_database.tag)..where((tbl) => tbl.id.equals(tagId))).getSingle().asStream();
  }
}