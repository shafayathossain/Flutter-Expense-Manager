import 'package:expense_manager/data/models/WalletWithBalance.dart';
import 'package:expense_manager/data/repositories/HomeRepositoryImpl.dart';
import 'package:expense_manager/ui/Router.dart';
import 'package:expense_manager/ui/home/CashFlowView.dart';
import 'package:expense_manager/ui/home/DayRangeChip.dart';
import 'package:expense_manager/ui/home/HomeBloc.dart';
import 'package:expense_manager/ui/home/HomeEvent.dart';
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

    return Scaffold(
      backgroundColor: Color(0xFFE5EAEC),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
      body: BlocProvider(
        create: (context) => _bloc,
        child: HomeBodyView(),
      ),
    );
  }
}

class HomeBodyView extends StatefulWidget {

  const HomeBodyView({ Key key }) : super(key: key);

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
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
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
            child: StreamBuilder(
              stream: BlocProvider.of<HomeBloc>(context).wallets,
              builder:
                  (context, AsyncSnapshot<List<WalletWithBalance>> snapshot) {
                int walletCount = 0;
                if (snapshot.hasData) {
                  walletCount = snapshot.data.length;
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: walletCount,
                  itemBuilder: (context, int index) {
                    return Provider(
                      create: (_) => snapshot.data[index],
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
    );
  }
}
