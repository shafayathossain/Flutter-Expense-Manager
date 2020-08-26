import 'package:expense_manager/data/models/EntryWithCategoryAndWallet.dart';
import 'package:expense_manager/ui/createentry/AddEntryEvents.dart';
import 'package:expense_manager/ui/createentry/AddEntryView.dart';
import 'package:expense_manager/ui/createentry/CreateEntryBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditEntryView extends StatelessWidget {
  EntryWithCategoryAndWallet entry;

  @override
  Widget build(BuildContext context) {
    this.entry = ModalRoute.of(context).settings.arguments;
    return BlocProvider(
      create: (context) => CreateEntryBloc(),
      child: Builder(
        builder: (contextB) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              actions: [
                MaterialButton(
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    BlocProvider.of<CreateEntryBloc>(contextB).add(SaveEvent());
                  },
                )
              ],
              title: Text("Edit Entry"),
            ),
            body: AddEntryFormWidget(
              (_) {},
              entry.mEntry.amount >= 0,
              entry: entry,
            ),
          );
        },
      ),
    );
  }
}
