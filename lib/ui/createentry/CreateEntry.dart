
import 'package:flutter/material.dart';
import 'AddExpenseEntryView.dart';

class CreateEntryPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            MaterialButton(
              child: Text("Save"),
            )
          ],
          title: Text("Add A Entry"),
          bottom: TabBar(
            tabs: [
              Text("expense".toUpperCase()),
              Text("income".toUpperCase()),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AddExpenseFormWidget(),
            Text("2")
          ],
        ),
      )
    );
  }
}
