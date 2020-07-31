import 'package:expense_manager/data/models/Category.dart';
import 'package:expense_manager/data/models/Entry.dart';
import 'package:expense_manager/data/models/Tag.dart';
import 'package:expense_manager/data/models/Wallet.dart';

class EntryWithCategoryAndWallet {

  EntryWithCategoryAndWallet(this.entry, this.category, this.tag, this.wallet);

  Entry entry;
  Category category;
  Tag tag;
  Wallet wallet;
}