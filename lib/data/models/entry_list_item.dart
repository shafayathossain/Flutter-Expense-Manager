import 'package:expense_manager/data/models/EntryWithCategoryAndWallet.dart';

class EntryListItem {
  int type;
  String date;
  EntryWithCategoryAndWallet item;

  EntryListItem(this.type, {this.date, this.item});
}
