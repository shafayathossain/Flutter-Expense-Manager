class AccountBookEvents {
  const AccountBookEvents();
}

class CreateAccountBookEvent extends AccountBookEvents {
  String name;
  int color;
  CreateAccountBookEvent({this.name, this.color});
}

class LoadAccountBookEvent extends AccountBookEvents {}