import 'dart:io';

import 'package:csv/csv.dart';
import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/account_book_with_balance.dart';
import 'package:expense_manager/data/repositories/AccountBookRepositoryImpl.dart';
import 'package:expense_manager/ui/Router.dart';
import 'package:expense_manager/ui/accountbook/AccountBookBloc.dart';
import 'package:expense_manager/ui/accountbook/AccountBookEvents.dart';
import 'package:expense_manager/ui/accountbook/AccountBookStates.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'CreateAccountBookDialog.dart';

class AccountBookScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountBookBloc(AccountBookRepositoryImpl(context)),
      child: Builder(
        builder: (contextB) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Account Books"),
                actions: [
                  MaterialButton(
                    child: Text("create".toUpperCase()),
                    textColor: Colors.white,
                    onPressed: () => showDialog(
                        context: contextB,
                        barrierDismissible: false,
                        builder: (contextC) => CreateAccountBookDialog(
                              callback: (name, color, id) {
                                BlocProvider.of<AccountBookBloc>(contextB)
                                  ..add(CreateAccountBookEvent(
                                      name: name, color: color));
                              },
                            )),
                  )
                ],
              ),
              body: Builder(
                builder: (context) {
                  BlocProvider.of<AccountBookBloc>(context)
                      .add(LoadAccountBookEvent());
                  return AccountBookView();
                },
              ));
        },
      ),
    );
  }
}

class AccountBookView extends StatefulWidget {
  List<AccountBookWithBalance> books = [];

  @override
  State createState() {
    return AccountBookViewStates();
  }
}

class AccountBookViewStates extends State<AccountBookView> {
  int _currentState = 0;
  int _selectedPosition = -1;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBookBloc, AccountBookStates>(
      listenWhen: (previousState, currentState) {
        return (currentState is ViewBookState) ||
            (currentState is ExportEntriesState);
      },
      listener: (context, state) {
        if (state is ViewBookState) {
          Navigator.pushReplacementNamed(context, HomeRoute);
        } else if (state is ExportEntriesState) {
          String csv = ListToCsvConverter().convert(state.row);
          _writeCsv(state.bookName, csv);
        }
      },
      buildWhen: (previousState, currentState) {
        return !((currentState is ViewBookState) ||
            (currentState is ExportEntriesState));
      },
      builder: (context, state) {
        if (state is AccountBookLoadedState &&
            state.accountBooks.length > 0 &&
            state.accountBooks[0].book != null) {
          widget.books = state.accountBooks;
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            itemCount: (state).accountBooks.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Provider(
                  create: (_) => widget.books[index],
                  child: AccountBookItemView(
                    selectedPosition: _selectedPosition,
                    currentPosition: index,
                    accountBookWithBalance: widget.books[index],
                    callback: (position) {
                      this._selectedPosition = position;
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          );
        } else {
          return Center(
            child: Text("No account book created"),
          );
        }
      },
    );
  }

  void _writeCsv(String bookName, String csv) async {
    Directory appDocDir = Theme.of(context).platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String filePath = appDocPath + "/${bookName}.csv";
    File file = File(filePath);
    file.writeAsString(csv);
    final snackBar = SnackBar(
      content: Text(
        Theme.of(context).platform == TargetPlatform.android
            ? "File saved in $filePath"
            : "File saved",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}

typedef AccountBookItemCallback(int position);

class AccountBookItemView extends StatelessWidget {
  int selectedPosition = -1;
  int currentPosition = -1;
  AccountBookWithBalance accountBookWithBalance;
  AccountBookItemCallback callback;

  AccountBookItemView(
      {this.selectedPosition,
      this.currentPosition,
      this.accountBookWithBalance,
      this.callback});

  Widget build(BuildContext context) {
    if (currentPosition == selectedPosition) {
      return Container(
        height: 150,
        margin: EdgeInsets.only(left: 10, right: 10),
        child: GestureDetector(
          onTap: () {
            callback.call(-1);
          },
          child: Card(
            margin: EdgeInsets.all(0),
            child: Stack(
              children: [
                Container(
                    height: 150,
                    child: GestureDetector(
                        child: Card(
                          margin: EdgeInsets.all(0),
                          color: Color(accountBookWithBalance.book.color),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      accountBookWithBalance.book.name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      (accountBookWithBalance.income -
                                              accountBookWithBalance.expense)
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Income",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              (accountBookWithBalance.income)
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Expense",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              (accountBookWithBalance.expense
                                                      .abs())
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          callback.call(currentPosition);
                        })),
                Positioned(
                  child: Container(
                    color: Colors.white60,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RawMaterialButton(
                              fillColor:
                                  Color(accountBookWithBalance.book.color),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.0))),
                              child: Text(
                                "view".toUpperCase(),
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                BlocProvider.of<AccountBookBloc>(context)
                                  ..add(ViewAccountBookEvent(context
                                      .read<AccountBookWithBalance>()
                                      .book));
                              },
                            ),
                            RawMaterialButton(
                              fillColor:
                                  Color(accountBookWithBalance.book.color),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.0))),
                              child: Text(
                                "export".toUpperCase(),
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                BlocProvider.of<AccountBookBloc>(context)
                                  ..add(ExportAccountBookEvent(context
                                      .read<AccountBookWithBalance>()
                                      .book));
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RawMaterialButton(
                              fillColor:
                                  Color(accountBookWithBalance.book.color),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.0))),
                              child: Text(
                                "edit".toUpperCase(),
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (contextC) =>
                                        CreateAccountBookDialog(
                                          book: accountBookWithBalance.book,
                                          callback: (name, color, id) {
                                            if (id == null) {
                                              BlocProvider.of<AccountBookBloc>(
                                                  context)
                                                ..add(CreateAccountBookEvent(
                                                    name: name, color: color));
                                            } else {
                                              BlocProvider.of<AccountBookBloc>(
                                                  context)
                                                ..add(EditAccountBookEvent(
                                                    name: name,
                                                    color: color,
                                                    id: id));
                                            }
                                          },
                                        ));
                              },
                            ),
                            RawMaterialButton(
                              fillColor:
                                  Color(accountBookWithBalance.book.color),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.0))),
                              child: Text(
                                "delete".toUpperCase(),
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                _showDeleteConfirmationDialog(
                                    context, accountBookWithBalance.book);
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
          height: 150,
          margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: GestureDetector(
              child: Card(
                margin: EdgeInsets.all(0),
                color: Color(accountBookWithBalance.book.color),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            accountBookWithBalance.book.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                "Balance",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                (accountBookWithBalance.income.abs() -
                                        accountBookWithBalance.expense.abs())
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Income",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    (accountBookWithBalance.income).toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Expense",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    (accountBookWithBalance.expense.abs())
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                callback.call(currentPosition);
              }));
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, account_book book) {
    showDialog(
        context: context,
        builder: (contextB) {
          return AlertDialog(
            title: Text(
              "DELETE ACCOUNT BOOK",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text("Do you really want to delete this account book?"),
            actions: <Widget>[
              RawMaterialButton(
                elevation: 0.0,
                highlightElevation: 0.0,
                fillColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3.0))),
                child: Text(
                  "yes".toUpperCase(),
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  BlocProvider.of<AccountBookBloc>(context)
                    ..add(DeleteAccountBookEvent(book));
                  Navigator.pop(context);
                },
              ),
              RawMaterialButton(
                elevation: 0.0,
                highlightElevation: 0.0,
                fillColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3.0))),
                child: Text(
                  "no".toUpperCase(),
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
