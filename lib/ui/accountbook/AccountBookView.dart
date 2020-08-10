
import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/AccountBook.dart';
import 'package:expense_manager/data/repositories/AccountBookRepositoryImpl.dart';
import 'package:expense_manager/ui/Router.dart';
import 'package:expense_manager/ui/accountbook/AccountBookBloc.dart';
import 'package:expense_manager/ui/accountbook/AccountBookEvents.dart';
import 'package:expense_manager/ui/accountbook/AccountBookStates.dart';
import 'package:expense_manager/ui/home/HomeBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                        builder:(contextC) => CreateAccountBookDialog(
                          callback: (name, color, id) {
                            print(name);
                            BlocProvider.of<AccountBookBloc>(contextB)..add(CreateAccountBookEvent(
                                name: name,
                                color: color
                            ));
                          },
                        )
                    ),
                  )
                ],
              ),
              body: Builder(
                builder: (context) {
                  BlocProvider.of<AccountBookBloc>(context).add(LoadAccountBookEvent());
                  return AccountBookView();
                },
              )
          );
        },
      ),
    );
  }
}

class AccountBookView extends StatefulWidget {

  List<account_book> books = [];

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
        return (currentState is ViewBookState);
      },
      listener: (context, state) {
        if(state is ViewBookState) {
          Navigator.pushReplacementNamed(context, HomeRoute);
        }
      },
      buildWhen: (previousState, currentState) {
        return !(currentState is ViewBookState);
      },
      builder: (context, state) {
        if(state is AccountBookLoadedState && state.accountBooks.length > 0) {
          widget.books = state.accountBooks;
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            itemCount: (state).accountBooks.length,
            itemBuilder: (BuildContext context, int index) {
              print(state.accountBooks);
              return Container(
                child: Provider(
                  create: (_) => widget.books[index],
                  child: AccountBookItemView(
                    selectedPosition: _selectedPosition,
                    currentPosition: index,
                    book: widget.books[index],
                    callback: (position) {
                      this._selectedPosition = position;
                      print("CALL $_selectedPosition $position");
                      setState(() {

                      });
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
}

typedef AccountBookItemCallback(int position);

class AccountBookItemView extends StatelessWidget {

  int selectedPosition = -1;
  int currentPosition = -1;
  account_book book;
  AccountBookItemCallback callback;

  AccountBookItemView({this.selectedPosition, this.currentPosition, this.book, this.callback});

  Widget build(BuildContext context) {
    print("$currentPosition -> ${book}");
    if(currentPosition == selectedPosition) {
      return Container(
        height: 150,
        child: GestureDetector(
          onTap: () {
            callback.call(-1);
          },
          child: Card(
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                color: Colors.black26,
                                child: Center(
                                  child: Text(
                                    book.name,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  child: Container(
                    color: Colors.white..withOpacity(0.1),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RawMaterialButton(
                              fillColor: Color(book.color),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(3.0))
                              ),
                              child: Text(
                                "view".toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                              onPressed: () {
                                BlocProvider.of<AccountBookBloc>(context)..add(ViewAccountBookEvent(context.read<account_book>()));
                              },
                            ),
                            RawMaterialButton(
                              fillColor: Color(book.color),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(3.0))
                              ),
                              child: Text(
                                "export".toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                              onPressed: () {

                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RawMaterialButton(
                              fillColor: Color(book.color),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(3.0))
                              ),
                              child: Text(
                                "edit".toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder:(contextC) => CreateAccountBookDialog(
                                      book: book,
                                      callback: (name, color, id) {
                                        print(name);
                                        if(id == null) {
                                          BlocProvider.of<AccountBookBloc>(context)
                                            ..add(CreateAccountBookEvent(
                                                name: name,
                                                color: color
                                            ));
                                        } else {
                                          BlocProvider.of<AccountBookBloc>(context)
                                            ..add(EditAccountBookEvent(
                                                name: name,
                                                color: color,
                                                id: id
                                            ));
                                        }
                                      },
                                    )
                                );
                              },
                            ),
                            RawMaterialButton(
                              fillColor: Color(book.color),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(3.0))
                              ),
                              child: Text(
                                "delete".toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                              onPressed: () {
                                _showDeleteConfirmationDialog(context);
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
          child: GestureDetector(
              child: Card(
                child: Center(
                  child: Text(book.name),
                ),
              ),
              onTap: () {
                callback.call(currentPosition);
              }
          )

      );
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (contextB) {
        return AlertDialog(
          title: Text(
            "DELETE ACCOUNT BOOK",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          content: Text(
            "Do you really want to delete this account book?"
          ),
          actions: <Widget>[
            RawMaterialButton(
              elevation: 0.0,
              highlightElevation: 0.0,
              fillColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3.0))
              ),
              child: Text(
                "yes".toUpperCase(),
                style: TextStyle(
                    color: Colors.blue,
                ),
              ),
              onPressed: () {
                BlocProvider.of<AccountBookBloc>(context)..add(DeleteAccountBookEvent(context.read<account_book>()));
                Navigator.pop(context);
              },
            ),
            RawMaterialButton(
              elevation: 0.0,
              highlightElevation: 0.0,
              fillColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3.0))
              ),
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
      }
    );
  }

}



