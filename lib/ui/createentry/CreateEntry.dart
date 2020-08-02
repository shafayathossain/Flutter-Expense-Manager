
import 'package:expense_manager/ui/createentry/AddEntryEvents.dart';
import 'package:expense_manager/ui/createentry/CreateEntryBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'AddEntryView.dart';

class CreateEntryPage extends StatefulWidget {

  Color appBarColor = Colors.blue;
  bool pageLoaded = false;

  @override
  State createState() {
    return CreateEntryPageState();
  }
}

class CreateEntryPageState extends State<CreateEntryPage> {

  Widget view;
  @override
  Widget build(BuildContext context) {
    if(!widget.pageLoaded) {
      view = TabBarView(
        children: [
          AddEntryFormWidget((int color) {
            widget.appBarColor = Color(color);
            setState(() {

            });
          }, false),
          AddEntryFormWidget((int color) {
            widget.appBarColor = Color(color);
            setState(() {

            });
          }, true),
        ],
      );
      widget.pageLoaded = true;
    }
    return BlocProvider(
      create: (_) => CreateEntryBloc(),
      child: Builder(
        builder: (contextB) {
          return DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: widget.appBarColor,
                  actions: [
                    MaterialButton(
                      child: Text("Save"),
                      onPressed: () {
                        BlocProvider.of<CreateEntryBloc>(contextB).add(SaveEvent());
                      },
                    )
                  ],
                  title: Text("Add A Entry"),
                  bottom: TabBar(
                    tabs: [
                      Container(
                        height: 50,
                        child: Center(
                          child: Text("expense".toUpperCase()),
                        ),
                      ),
                      Container(
                        height: 50,
                        child: Center(
                          child: Text("income".toUpperCase()),
                        ),
                      ),
                    ],
                  ),
                ),
                body: view,
              )
          );
        },
      ),
    );
  }
}
