import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';

class AccountBookEvents {
  const AccountBookEvents();
}

class CreateAccountBookEvent extends AccountBookEvents {
  String name;
  int color;
  CreateAccountBookEvent({this.name, this.color});
}

class EditAccountBookEvent extends AccountBookEvents {
  String name;
  int color;
  int id;
  EditAccountBookEvent({this.name, this.color, this.id});
}

class LoadAccountBookEvent extends AccountBookEvents {}

class ViewAccountBookEvent extends AccountBookEvents {
  account_book book;

  ViewAccountBookEvent(this.book);
}

class DeleteAccountBookEvent extends AccountBookEvents {
  account_book book;

  DeleteAccountBookEvent(this.book);
}

class ExportAccountBookEvent extends AccountBookEvents {
  account_book book;

  ExportAccountBookEvent(this.book);
}