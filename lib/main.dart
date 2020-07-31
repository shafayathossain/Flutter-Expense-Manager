import 'package:expense_manager/data/localdb/LocalDatabase.dart';
import 'package:expense_manager/ui/Router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ExpenseManagerApp(),
  );
}

class ExpenseManagerApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Provider<LocalDatabase>(
      create: (context) => LocalDatabase(),
      child: MaterialApp(
        title: 'Expense Manager',
        theme: ThemeData.light(),
        onGenerateRoute: Router.generateRoute,
        initialRoute: AccountBookRoute,
      ),
      dispose: (context, db) => db.close(),
    );
  }
}