import 'dart:math';

import 'package:expense_manager/data/models/WalletWithBalance.dart';
import 'package:expense_manager/data/repositories/HomeRepositoryImpl.dart';
import 'package:expense_manager/ui/Router.dart';
import 'package:expense_manager/ui/home/CashFlowView.dart';
import 'package:expense_manager/ui/home/DayRangeChip.dart';
import 'package:expense_manager/ui/home/HomeBloc.dart';
import 'package:expense_manager/ui/home/HomeEvent.dart';
import 'package:expense_manager/ui/home/HomeState.dart';
import 'package:expense_manager/ui/home/WalletItemView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {

  HomeBloc _bloc;

  @override
  Widget build(BuildContext context) {

    _bloc = HomeBloc(HomeRepositoryImpl(context));
    return BlocProvider(
      create: (context) => _bloc,
      child: Builder(
        builder: (contextB) {
          _bloc.add(GetAccountBookEvent());
          return BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {
              if(state is ClearAccountBookState) {
                Navigator.pushReplacementNamed(context, AccountBookRoute);
              }
            },
            listenWhen: (context, state) => state is HomeState,
            buildWhen: (context, state) => state is GetAccountBookState,
            builder: (context, state) {
              return Scaffold(
                backgroundColor: Color(0xFFE5EAEC),
                appBar: AppBar(
                  backgroundColor: Colors.blue,
                  title: Text(
                    state == null ? "Home" : (state as GetAccountBookState).book.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  actions: <Widget>[
                    MaterialButton(
                      child: Text("change".toUpperCase()),
                      textColor: Colors.white,
                      onPressed: () {
                        _bloc.add(ClearAccountBookEvent());
                      },
                    )
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  child: Image.asset(
                    "assets/images/ic_plus.png",
                    width: 24,
                    height: 24,
                    alignment: Alignment.centerLeft,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, CreateEntryRout)
                        .then((value) => _bloc.add(ResumeEvent()));
                  },
                ),
                body: HomeBodyView(),
              );
            },
          );
        },
      ),
    );
  }
}

class HomeBodyView extends StatefulWidget {

  Key walletListKey = new Key(
      Random(
          DateTime.now().millisecondsSinceEpoch
      )
          .nextInt(1000)
          .toString());

  HomeBodyView({ Key key }) : super(key: key);

  @override
  State createState() {
    return HomeBodyState();
  }
}

class HomeBodyState extends State<HomeBodyView> with WidgetsBindingObserver {
  int _selectedPosition;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if(state == AppLifecycleState.resumed) {
      BlocProvider.of<HomeBloc>(context).add(ResumeEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<HomeBloc>(context).add(GetWalletsEvent());
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, top: 10),
              child: Text(
                "Wallets",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            Container(
              height: 150,
              margin: EdgeInsets.only(left: 10, top: 10),
              child: BlocConsumer<HomeBloc, HomeState>(
                listener: (context, state) {},
                buildWhen: (context, state) => state is WalletsState,
                builder: (context, state) {
                  int walletCount = 0;
                  walletCount = !(state is WalletsState) ? 0 :(state as WalletsState).wallets.length;
                  print(walletCount);
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: walletCount,
                    itemBuilder: (context, int index) {
                      return Provider(
                        create: (_) => (state as WalletsState).wallets[index],
                        key: ValueKey((state as WalletsState).wallets[index].balance),
                        child: WalletItemView(
                          selectedPosition: _selectedPosition,
                          currentPosition: index,
                          callback: (position) {
                            _selectedPosition = position;
                            setState(() { });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            CashFlowView(),
          ],
        ),
      ),
    );
  }
}
