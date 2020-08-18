import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

typedef void AdjustWalletBalanceDialogCallback(double amount);

class AdjustWalletBalanceDialog extends StatelessWidget {

  final AdjustWalletBalanceDialogCallback callback;
  final _formKey = GlobalKey<FormState>();
  final currentAmountTextController = TextEditingController();

  AdjustWalletBalanceDialog({this.callback});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Provider(
            create: (_) => callback,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(2.0))
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(
                            top: 15.0,
                            left: 10.0
                        ),
                        width: double.maxFinite,
                        child: Text(
                          "ADJUST BALANCE",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                    Container(
                        margin: EdgeInsets.only( top: 15.0),
                        child: Divider(
                          height: 1,
                          color: Colors.blueGrey,
                        )
                    ),
                    Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(
                            left: 10.0,
                            top: 20.0,
                            right: 0.0,
                            bottom: 0.0),
                        child: Text(
                          "Current Balance",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        )
                    ),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.only(
                          left: 10.0,
                          top: 10.0,
                          right: 10.0,
                          bottom: 0.0),
                      child: TextFormField(
                        maxLines: 1,
                        controller: currentAmountTextController,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Text is empty';
                          }
                          return null;
                        },
                        onChanged: (text) {
                          if(text.length > 1) {
                            _formKey.currentState.validate();
                          }
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Enter current balance",
                            filled: true,
                            fillColor: Color(0xFFD3DADD),
                            hintStyle: TextStyle(
                                color: Color(0xFF263238)
                            ),
                            errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(3.0))
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(3.0))
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(3.0))
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(3.0))
                            )
                        ),
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RawMaterialButton(
                            elevation: 0.0,
                            highlightElevation: 0.0,
                            fillColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(3.0))
                            ),
                            child: Text(
                              "cancel".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            onPressed: () => {
                              Navigator.pop(context)
                            },
                          ),
                          RawMaterialButton(
                            elevation: 0.0,
                            highlightElevation: 0.0,
                            fillColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(3.0))
                            ),
                            child: Text(
                              "create".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            onPressed: () {
                              if(_formKey.currentState.validate()) {
                                callback.call(
                                    double.parse(currentAmountTextController.text)
                                );
                                Navigator.pop(context);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Enter a valid amount",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );

                              }
                            },
                          ),
                        ]
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: () {}
    );
  }
}