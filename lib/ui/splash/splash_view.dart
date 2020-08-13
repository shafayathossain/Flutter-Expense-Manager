import 'package:expense_manager/data/repositories/AccountBookRepositoryImpl.dart';
import 'package:expense_manager/ui/Router.dart';
import 'package:expense_manager/ui/splash/splash_bloc.dart';
import 'package:expense_manager/ui/splash/splash_event.dart';
import 'package:expense_manager/ui/splash/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc(AccountBookRepositoryImpl(context)),
      child: Builder(
        builder: (contextB) {
          BlocProvider.of<SplashBloc>(contextB).add(SplashEvent());
          return BlocListener(
            listener: (context, state) {
              if(state is SplashState && state.bookId == null) {
                Navigator.pushReplacementNamed(contextB, AccountBookRoute);
              } else {
                Navigator.pushReplacementNamed(contextB, HomeRoute);
              }
            },
            bloc: BlocProvider.of<SplashBloc>(contextB),
            child: Container(),
          );
        },
      ),
    );
  }
}