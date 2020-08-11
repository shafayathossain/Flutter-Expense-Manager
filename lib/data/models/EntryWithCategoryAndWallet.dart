import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';

class EntryWithCategoryAndWallet {

  EntryWithCategoryAndWallet(this.mEntry, this.mCategory, this.mTag, this.mWallet);

  entry mEntry;
  category mCategory;
  tag mTag;
  wallet mWallet;
}