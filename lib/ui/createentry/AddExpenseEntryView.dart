import 'dart:ui';

import 'package:expense_manager/data/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/repositories/EntryRepositoryImpl.dart';
import 'package:expense_manager/ui/ChipGroup.dart';
import 'package:expense_manager/ui/createentry/AddEntryBloc.dart';
import 'package:expense_manager/ui/createentry/AddEntryStates.dart';
import 'package:expense_manager/ui/createentry/CalculatorKeyBoardView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'AddEntryEvents.dart';
import 'dialogs/CreateCategoryDialog.dart';
import 'dialogs/CreateTagDialog.dart';

class AddExpenseFormWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddEntryBloc(EntryRepositoryImpl(context)),
      child: Builder(
        builder: (contextB) {
          print("Calling block add event");
          BlocProvider.of<AddEntryBloc>(contextB)..add(GetCategoriesEvent());
          BlocProvider.of<AddEntryBloc>(contextB)..add(GetWalletsEvent());
          return AddExpenseStatefulFormWidget();
        }
      ),
    );
  }
}

class AddExpenseStatefulFormWidget extends StatefulWidget {

  @override
  State createState() {
    return AddExpenseState();
  }
}

class AddExpenseState extends State<AddExpenseStatefulFormWidget> with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  TextEditingController _amountTextController = TextEditingController();
  List<category> _categories = [];
  category _selectedCategory;
  wallet _selectedWallet;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 500)
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1),
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Stack(
          children: [
            NotificationListener(
              onNotification: (_) {
                print(_controller.status);
                if(_controller.status == AnimationStatus.completed) {
                  _controller.reverse();
                }
                return true;
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(
                            left: 10.0,
                            top: 20.0,
                            right: 0.0,
                            bottom: 0.0),
                        child: Text(
                          "Amount",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        )
                    ),
                    Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(
                            left: 10.0,
                            top: 10.0,
                            right: 10.0,
                            bottom: 0.0),
                        child: StreamBuilder(
                          stream: BlocProvider.of<AddEntryBloc>(context).amountFormula,
                          builder: (context, snapshot) {
                            return TextFormField(
                              maxLines: 1,
                              showCursor: true,
                              readOnly: true,
                              controller: _amountTextController,
                              onTap: () {
                                _controller.forward();
                              },
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Text is empty';
                                } else {

                                }
                                return null;
                              },
                              onChanged: (text) {
                                if(text.length > 1) {
                                  _formKey.currentState.validate();
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: "Enter amount",
                                  errorText: snapshot.error != null ? snapshot.error.toString().split(':')[1] : null,
                                  filled: true,
                                  fillColor: Color(0xFFD3DADD),
                                  hintStyle: TextStyle(
                                      color: Color(0xFF263238)
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(3.0))
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(3.0))
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(3.0))
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(3.0))
                                  )
                              ),
                            );
                          },
                        )
                    ),
                    Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(
                            left: 10.0,
                            top: 20.0,
                            right: 0.0,
                            bottom: 0.0),
                        child: Text(
                          "Date",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        )
                    ),
                    Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(
                            left: 10.0,
                            top: 10.0,
                            right: 10.0,
                            bottom: 0.0),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            TextFormField(
                              maxLines: 1,
                              showCursor: true,
                              readOnly: true,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Text is empty';
                                }
                                return null;
                              },
                              onChanged: (text) {
                                if(text.length > 1) {
                                  _formKey.currentState.validate();
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: "Select task date",
                                  filled: true,
                                  fillColor: Color(0xFFD3DADD),
                                  hintStyle: TextStyle(
                                      color: Color(0xFF263238)
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(3.0))
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(3.0))
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(3.0))
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(3.0))
                                  )
                              ),
                            ),
                            Container(
                              height: 48,
                              width: 50,
                              child: RawMaterialButton(
                                fillColor: Colors.pink,
                                padding: EdgeInsets.all(0),
                                child: Container(
                                  child: Image.asset("assets/images/ic_calendar.png"),
                                ),
                                onPressed: () {

                                },
                              ),
                            )
                          ],
                        )
                    ),
                    Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(
                            left: 10.0,
                            top: 20.0,
                            right: 0.0,
                            bottom: 0.0),
                        child: Text(
                          "Category",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        )
                    ),
                    Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(
                            left: 10.0,
                            top: 10.0,
                            right: 10.0,
                            bottom: 0.0),
                        child: StreamBuilder(
                          stream: BlocProvider.of<AddEntryBloc>(context).categories,
                          builder: (context, AsyncSnapshot<List<category>> snapshot) {
                            if(snapshot.hasData) {
                              return ChipGroup(
                                snapshot.data.map((e) => e.name).toList(),
                                chipColors: snapshot.data.map((e) => e.color).toList(),
                                onChipSelectedCallback: (int index) {
                                  _selectedCategory = snapshot.data[index];
                                  BlocProvider.of<AddEntryBloc>(context)..add(GetTagsEvent(snapshot.data[index].id));
                                }
                              );
                            } else {
                              return ChipGroup([]);
                            }
                          },
                        )
                    ),
                    Container(
                      height: 45,
                      margin: EdgeInsets.only(
                          left: 10.0,
                          top: 10.0,
                          right: 10.0,
                          bottom: 0.0),
                      child: RaisedButton(
                        color: Colors.white,
                        disabledColor: Colors.white,
                        highlightColor: Colors.white70,
                        splashColor: Colors.blue.withOpacity(0.2),
                        elevation: 0,
                        onPressed: (){
                          _showAddCategoryDialog();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                          side: BorderSide(
                              color: Colors.blue,
                              width: 2
                          ),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/ic_add.png",
                              width: 24,
                              height: 24,
                              alignment: Alignment.centerLeft,
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  "add category".toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.blue
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(
                            left: 10.0,
                            top: 20.0,
                            right: 0.0,
                            bottom: 0.0),
                        child: Text(
                          "Wallet",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        )
                    ),
                    Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(
                            left: 10.0,
                            top: 10.0,
                            right: 10.0,
                            bottom: 0.0),
                        child: StreamBuilder(
                          stream: BlocProvider.of<AddEntryBloc>(context).wallets,
                          builder: (context, AsyncSnapshot<List<wallet>> snapshot) {
                            if(snapshot.hasData) {
                              return ChipGroup(
                                  snapshot.data.map((e) => e.name).toList(),
                                  chipColors: snapshot.data.map((e) => e.color).toList(),
                                  onChipSelectedCallback: (int index) {
                                    _selectedWallet = snapshot.data[index];
                                    BlocProvider.of<AddEntryBloc>(context)..add(GetTagsEvent(snapshot.data[index].id));
                                  }
                              );
                            } else {
                              return ChipGroup([]);
                            }
                          },
                        )
                    ),
                    StreamBuilder(
                      stream: BlocProvider.of<AddEntryBloc>(context).tags,
                      builder: (context, AsyncSnapshot<List<tag>> snapshot) {
                        if(snapshot.hasData) {
                          return Column(
                            children: [
                              Container(
                                  width: double.maxFinite,
                                  margin: EdgeInsets.only(
                                      left: 10.0,
                                      top: 20.0,
                                      right: 0.0,
                                      bottom: 0.0),
                                  child: Text(
                                    "Tag",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  )
                              ),
                              Container(
                                  width: double.maxFinite,
                                  margin: EdgeInsets.only(
                                      left: 10.0,
                                      top: 10.0,
                                      right: 10.0,
                                      bottom: 0.0),
                                  child: ChipGroup(
                                    snapshot.data.map((e) => e.name).toList(),
                                    chipColors: snapshot.data.map((e) => e.color).toList(),
                                  )
                              ),
                              Container(
                                height: 45,
                                margin: EdgeInsets.only(
                                    left: 10.0,
                                    top: 10.0,
                                    right: 10.0,
                                    bottom: 0.0),
                                child: RaisedButton(
                                  color: Colors.white,
                                  disabledColor: Colors.white,
                                  highlightColor: Colors.white70,
                                  splashColor: Colors.blue.withOpacity(0.2),
                                  elevation: 0,
                                  onPressed: (){
                                    _showAddTagDialog();
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    side: BorderSide(
                                        color: Colors.blue,
                                        width: 2
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/ic_add.png",
                                        width: 24,
                                        height: 24,
                                        alignment: Alignment.centerLeft,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            "add tag".toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.blue
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(
                            left: 10.0,
                            top: 20.0,
                            right: 0.0,
                            bottom: 0.0),
                        child: Text(
                          "Description",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        )
                    ),
                    Container(
                        width: double.maxFinite,
                        height: 100,
                        margin: EdgeInsets.only(
                            left: 10.0,
                            top: 10.0,
                            right: 10.0,
                            bottom: 20.0),
                        child: GestureDetector(
                          child: TextFormField(
                            maxLines: 100,
                            showCursor: true,
                            readOnly: true,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Text is empty';
                              }
                              return null;
                            },
                            onChanged: (text) {
                              if(text.length > 1) {
                                _formKey.currentState.validate();
                              }
                            },
                            decoration: InputDecoration(
                                hintText: "Type your description here",
                                filled: true,
                                fillColor: Color(0xFFD3DADD),
                                hintStyle: TextStyle(
                                    color: Color(0xFF263238)
                                ),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(Radius.circular(3.0))
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(Radius.circular(3.0))
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(Radius.circular(3.0))
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(Radius.circular(3.0))
                                )
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
            SlideTransition(
              position: _offsetAnimation,
              child: CalculatorKeyBoardView(
                textController: _amountTextController,
                callback: (value) {
                  BlocProvider.of<AddEntryBloc>(context).amountValidator.sink.add(value);
                },
              ),
            )
          ],
        )
    );
  }

  void _showAddCategoryDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder:(contextC) => CreateCategoryDialog(
          (name, color) {
            print(name);
            BlocProvider.of<AddEntryBloc>(context)..add(CreateCategoryEvent(
                name, color
            ));
          },
        )
    );
  }

  void _showAddTagDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder:(contextC) => CreateTagDialog(
              (name, color) {
            print(name);
            BlocProvider.of<AddEntryBloc>(context)..add(CreateTagEvent(
                name, color, _selectedCategory.id
            ));
          },
        )
    );
  }
}