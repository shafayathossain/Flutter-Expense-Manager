
import 'package:expense_manager/data/models/WalletWithBalance.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef void WalletItemCallback(int index);

class WalletItemView extends StatelessWidget {

  int selectedPosition = -1;
  int currentPosition = -1;
  WalletItemCallback callback;

  WalletItemView({this.selectedPosition, this.currentPosition, this.callback});

  Widget build(BuildContext context) {
    print("$currentPosition -> ${currentPosition == selectedPosition}");
    final walletInformationView = getWalletInformationView(context);
    if(currentPosition == selectedPosition) {
      return Container(
        height: 150,
        width: 300,
        child: GestureDetector(
          onTap: () {
            callback.call(-1);
          },
          child: Stack(
            children: [
              Positioned(
                child: getWalletInformationView(context),
              ),
              Positioned(
                child: Container(
                  color: Colors.white60,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RawMaterialButton(
                            fillColor: Color(context.watch<WalletWithBalance>().mWallet.color),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(3.0))
                            ),
                            child: Text(
                              "adjust".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                            onPressed: () {

                            },
                          ),
                          RawMaterialButton(
                            fillColor: Color(context.watch<WalletWithBalance>().mWallet.color),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(3.0))
                            ),
                            child: Text(
                              "delete".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                            onPressed: () {

                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
          height: 150,
          width: 300,
          child: GestureDetector(
              child: getWalletInformationView(context),
              onTap: () {
                callback.call(currentPosition);
              }
          )

      );;
    }
  }

  Widget getWalletInformationView(BuildContext context) {
    return Card(
      color: Color(context.watch<WalletWithBalance>().mWallet.color),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            child:  Text(
              context.watch<WalletWithBalance>().mWallet.name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: 10,
                right: 10
            ),
            child: LinearPercentIndicator(
              lineHeight: 15.0,
              percent: context.watch<WalletWithBalance>().balancePercent,
              animation: true,
              progressColor: Colors.white,
              linearStrokeCap: LinearStrokeCap.roundAll,
            ),
          ),
          Container(
              margin: EdgeInsets.only(
                  left: 10,
                  right: 10
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Balance",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${context.watch<WalletWithBalance>().balance}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Deposit",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${context.watch<WalletWithBalance>().income}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
          )
        ],
      ),
    );
  }
}