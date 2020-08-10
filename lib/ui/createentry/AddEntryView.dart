import 'dart:ui';

import 'package:expense_manager/data/datasources/localdb/LocalDatabase.dart';
import 'package:expense_manager/data/repositories/EntryRepositoryImpl.dart';
import 'package:expense_manager/ui/ChipGroup.dart';
import 'package:expense_manager/ui/createentry/AddEntryBloc.dart';
import 'package:expense_manager/ui/createentry/AddEntryStates.dart';
import 'package:expense_manager/ui/createentry/CalculatorKeyBoardView.dart';
import 'package:expense_manager/ui/createentry/CreateEntryBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'AddEntryEvents.dart';
import 'dialogs/CreateCategoryDialog.dart';
import 'dialogs/CreateTagDialog.dart';

typedef void CategorySelectionCallback(int color);

class AddEntryFormWidget extends StatelessWidget {

  CategorySelectionCallback categorySelectionCallback;
  bool isIncome = false;

  AddEntryFormWidget(this.categorySelectionCallback, this.isIncome);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddEntryBloc(EntryRepositoryImpl(context)),
      child: Builder(
        builder: (contextB) {
          print("Calling block add event");
          BlocProvider.of<AddEntryBloc>(contextB)..add(GetCategoriesEvent(isIncome));
          BlocProvider.of<AddEntryBloc>(contextB)..add(GetWalletsEvent());
          return AddEntryStatefulFormWidget(categorySelectionCallback, isIncome);
        }
      ),
    );
  }
}

class AddEntryStatefulFormWidget extends StatefulWidget {

  CategorySelectionCallback categorySelectionCallback;
  bool isIncome = false;

  AddEntryStatefulFormWidget(this.categorySelectionCallback, this.isIncome);

  @override
  State createState() {
    return AddEntryState();
  }
}

class AddEntryState extends State<AddEntryStatefulFormWidget> with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  CalendarController _calendarController = CalendarController();
  TextEditingController _amountTextController = TextEditingController();
  TextEditingController _dateTextController = TextEditingController();
  TextEditingController _descriptionTextController = TextEditingController();
  List<category> _categories = [];
  category _selectedCategory;
  wallet _selectedWallet;
  tag _selectedTag;
  Widget view;

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
    print("BUILD");
    if(!BlocProvider.of<AddEntryBloc>(context).errorSubject.hasListener) {
      BlocProvider
          .of<AddEntryBloc>(context)
          .errorSubject
          .listen((event) {
        print(event);
        final snackBar = SnackBar(
          content: Text(
            event.toString(),
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,

        );
        Scaffold.of(context).showSnackBar(snackBar);
      });
    }
    return Form(
        key: _formKey,
        child: BlocBuilder(
          bloc: BlocProvider.of<AddEntryBloc>(context),
          buildWhen: (context, state) => state == EntrySavedState,
          builder: (context, state) {
            print("STATE REFRESHED $state");
            return StreamBuilder(
                stream: BlocProvider.of<CreateEntryBloc>(context).saveButtonListener,
                builder: (context, AsyncSnapshot<int> snapshot) {
                  if(snapshot.hasData && snapshot.data == 1) {
                    BlocProvider.of<AddEntryBloc>(context).add(SaveEvent(
                      amountString: _amountTextController.text.toString(),
                      date: _dateTextController.text.toString(),
                      selectedCategory: _selectedCategory,
                      selectedWallet: _selectedWallet,
                      selectedTag: _selectedTag,
                      description: _descriptionTextController.text.toString(),
                      isIncome: widget.isIncome
                    ));
                  } else if(view == null) {
                    view = Stack(
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
                                        if(snapshot.hasData) {
                                          _amountTextController.text = snapshot.data as String;
                                          _amountTextController.selection = TextSelection.collapsed(offset: _amountTextController.text.length);
                                        }
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
                                          showCursor: false,
                                          readOnly: true,
                                          controller: _dateTextController,
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
                                          onTap: () {
                                            _showDatePicker();
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
                                              _showDatePicker();
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
                                                this.widget.categorySelectionCallback.call(snapshot.data[index].color);
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
                                    if(snapshot.hasData && snapshot.data.length > 0) {
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
                                                onChipSelectedCallback: (int index) {

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
                    );
                  }
                  return view;
                },
              );
          },
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
                name, color, widget.isIncome
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

  void _showDatePicker() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      useRootNavigator: true,
      builder: (ctx) {
        return Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RawMaterialButton(
                    elevation: 0,
                    hoverElevation: 0,
                    highlightElevation: 0,
                    focusElevation: 0,
                    disabledElevation: 0,
                    child: Text(
                      "cancel".toUpperCase(),
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.red
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  RawMaterialButton(
                    elevation: 0,
                    hoverElevation: 0,
                    highlightElevation: 0,
                    focusElevation: 0,
                    disabledElevation: 0,
                    child: Text(
                      "select".toUpperCase(),
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue
                      ),
                    ),
                    onPressed: () {
                      _setDateToDateField(_calendarController.selectedDay);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TableCalendar(
                      calendarController: _calendarController,
                      rowHeight: 40,
                      headerStyle: HeaderStyle(
                          centerHeaderTitle: true,
                          formatButtonVisible: false
                      ),
                      calendarStyle: CalendarStyle(
                          weekendStyle: TextStyle(
                              color: Colors.black
                          ),
                          outsideDaysVisible: false
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        );
      }
    );
  }
  void _setDateToDateField(DateTime selectedDay) {
    final formatter = DateFormat("dd-MM-yyyy");
    String date = formatter.format(selectedDay);
    _dateTextController.text = date;
  }
}