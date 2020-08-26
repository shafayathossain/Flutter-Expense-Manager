import 'package:expense_manager/ui/accountbook/AccountBookView.dart';
import 'package:expense_manager/ui/createentry/CreateEntry.dart';
import 'package:expense_manager/ui/home/HomeView.dart';
import 'package:expense_manager/ui/splash/splash_view.dart';
import 'package:flutter/material.dart';

import 'entries/entries_view.dart';

const String SplashRoute = "/";
const String AccountBookRoute = "account_book";
const String HomeRoute = "home";
const String CreateEntryRout = "create_entry";
const String EntriesRoute = "entries";

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashRoute:
        return MaterialPageRoute(builder: (_) => SplashView());
      case AccountBookRoute:
        return MaterialPageRoute(builder: (_) => AccountBookScreen());
      case HomeRoute:
        return MaterialPageRoute(builder: (_) => HomeView());
      case CreateEntryRout:
        return MaterialPageRoute(builder: (_) => CreateEntryPage());
      case EntriesRoute:
        return MaterialPageRoute(
            builder: (_) => EntriesView(), settings: settings);
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
