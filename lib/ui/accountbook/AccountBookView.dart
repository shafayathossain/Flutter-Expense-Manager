
import 'package:expense_manager/data/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/models/AccountBook.dart';
import 'package:expense_manager/data/repositories/AccountBookRepositoryImpl.dart';
import 'package:expense_manager/ui/accountbook/AccountBookBloc.dart';
import 'package:expense_manager/ui/accountbook/AccountBookEvents.dart';
import 'package:expense_manager/ui/accountbook/AccountBookStates.dart';
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
                          callback: (name, color) {
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

    return BlocBuilder<AccountBookBloc, AccountBookStates>(
      builder: (context, state) {
        if(state is AccountBookLoadedState && state.accountBooks.length > 0) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            itemCount: (state).accountBooks.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Provider(
                  create: (_) => (state).accountBooks[index],
                  child: AccountBookItemView(
                    selectedPosition: _selectedPosition,
                    currentPosition: index,
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
  AccountBookItemCallback callback;

  AccountBookItemView({this.selectedPosition, this.currentPosition, this.callback});

  Widget build(BuildContext context) {
    print("$currentPosition -> ${currentPosition == selectedPosition}");
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
                                    context.watch<account_book>().name,
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
                              fillColor: Color(context.watch<account_book>().color),
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

                              },
                            ),
                            RawMaterialButton(
                              fillColor: Color(context.watch<account_book>().color),
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
                              fillColor: Color(context.watch<account_book>().color),
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

                              },
                            ),
                            RawMaterialButton(
                              fillColor: Color(context.watch<account_book>().color),
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
                  child: Text(context.watch<account_book>().name),
                ),
              ),
              onTap: () {
                callback.call(currentPosition);
              }
          )

      );
    }
  }

}



