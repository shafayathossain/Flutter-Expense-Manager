
import 'package:expense_manager/ui/accountbook/AccountBookView.dart';
import 'package:expense_manager/ui/createentry/CreateEntry.dart';
import 'package:expense_manager/ui/home/HomeView.dart';
import 'package:flutter/material.dart';

const String AccountBookRoute = "/";
const String HomeRoute = "home";
const String CreateEntryRout = "create_entry";

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AccountBookRoute:
        return MaterialPageRoute(builder: (_) => AccountBookScreen());
      case HomeRoute:
        return MaterialPageRoute(builder: (_) => HomeView());
      case CreateEntryRout:
        return MaterialPageRoute(builder: (_) => CreateEntryPage());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}')),
            ));
    }
  }
}