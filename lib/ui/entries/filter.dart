import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/category_with_tags.dart';
import 'package:expense_manager/ui/ChipGroup.dart';
import 'package:flutter/material.dart';

typedef OnFilter(
    List<int> selectedWalletIndexes, List<CategoryWithTags> checkedCategories);

class Filter extends StatelessWidget {
  final List<wallet> wallets;
  final List<CategoryWithTags> categories;
  List<int> selectedWalletIndexes = [];
  List<CategoryWithTags> checkedCategories = [];
  OnFilter onFilter;

  Filter(this.wallets, this.categories, this.onFilter,
      {this.selectedWalletIndexes, this.checkedCategories});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          color: Colors.blue,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0))),
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(
                    "Filter",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: <Widget>[
                    MaterialButton(
                      height: 50,
                      child: Text(
                        "Clear",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        selectedWalletIndexes = [];
                        checkedCategories = [];
                        onFilter.call(selectedWalletIndexes, checkedCategories);
                        Navigator.pop(context);
                      },
                    ),
                    MaterialButton(
                      height: 50,
                      child: Text(
                        "Apply",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        onFilter.call(selectedWalletIndexes, checkedCategories);
                        Navigator.pop(context);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 15, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Wallets",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ChipGroup(
                    wallets.map((e) => e.name).toList(),
                    chipColors: wallets.map((e) => e.color).toList(),
                    multipleSelectionEnabled: true,
                    selectedIndexes: selectedWalletIndexes != null
                        ? selectedWalletIndexes
                        : [],
                    onChipSelectedCallback: (List<int> indexes) {
                      if (indexes != null) {
                        selectedWalletIndexes = indexes;
                      }
                    },
                  ),
                ]..addAll(List.generate(categories.length, (index) {
                    int indexOfCheckedCategory = checkedCategories != null
                        ? checkedCategories.indexWhere((element) =>
                            element.mCategory.id ==
                            categories[index].mCategory.id)
                        : -1;
                    return FilterCategoryItemView(
                        indexOfCheckedCategory < 0
                            ? categories[index]
                            : checkedCategories[indexOfCheckedCategory],
                        (categoryWithTags, isChecked) {
                      if (isChecked) {
                        if (checkedCategories != null &&
                            checkedCategories.indexWhere((element) =>
                                    element.mCategory.id ==
                                    categoryWithTags.mCategory.id) <
                                0) {
                          checkedCategories.add(categoryWithTags);
                        }
                      } else {
                        int categoryIndex = checkedCategories == null
                            ? -1
                            : checkedCategories.indexWhere((element) =>
                                element.mCategory.id ==
                                categoryWithTags.mCategory.id);
                        if (categoryIndex >= 0) {
                          checkedCategories.removeAt(categoryIndex);
                        }
                      }
                    });
                  })),
              ),
            ),
          ),
        )
      ],
    );
  }
}

typedef OnCategoryCheckedChange(
    CategoryWithTags categoryWithTags, bool isChecked);

class FilterCategoryItemView extends StatefulWidget {
  CategoryWithTags categoryWithTags;
  final OnCategoryCheckedChange onCheckedChange;
  bool isChecked = false;

  FilterCategoryItemView(this.categoryWithTags, this.onCheckedChange) {
    isChecked = categoryWithTags.checkedTagIndexes != null &&
        categoryWithTags.checkedTagIndexes.length > 0;
  }

  @override
  State createState() {
    return FilterCategoryItemViewState();
  }
}

class FilterCategoryItemViewState extends State<FilterCategoryItemView> {
  @override
  Widget build(BuildContext context) {
    widget.onCheckedChange.call(widget.categoryWithTags, widget.isChecked);
    return Wrap(
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    value: widget.isChecked,
                    onChanged: (isChecked) {
                      setState(() {
                        widget.isChecked = !widget.isChecked;
                        if (!widget.isChecked) {
                          widget.categoryWithTags.checkedTagIndexes = [];
                        }
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.isChecked = !widget.isChecked;
                        if (!widget.isChecked) {
                          widget.categoryWithTags.checkedTagIndexes = [];
                        }
                      });
                    },
                    child: Text(
                      widget.categoryWithTags.mCategory.name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              ChipGroup(
                widget.categoryWithTags.tags.map((e) => e.name).toList(),
                chipColors:
                    widget.categoryWithTags.tags.map((e) => e.color).toList(),
                multipleSelectionEnabled: true,
                selectedIndexes: widget.categoryWithTags.checkedTagIndexes,
                onChipSelectedCallback: (List<int> indexes) {
                  setState(() {
                    widget.categoryWithTags.checkedTagIndexes = indexes;
                    widget.isChecked = true;
                  });
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
