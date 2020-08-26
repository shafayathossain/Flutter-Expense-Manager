import 'dart:math';

import 'package:flutter/material.dart';

typedef void CalculatorKeyBoardCallback(String value);

class CalculatorKeyBoardView extends StatelessWidget {
  final TextEditingController textController;
  final CalculatorKeyBoardCallback callback;

  CalculatorKeyBoardView({this.textController, this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            fillColor: Colors.white,
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            child: Text(
                              "(".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.blueAccent),
                            ),
                            onPressed: () {
                              _setText("(");
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            fillColor: Colors.white,
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            child: Text(
                              ")".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.blueAccent),
                            ),
                            onPressed: () {
                              _setText(")");
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            fillColor: Colors.white,
                            child: Text(
                              "/".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.blueAccent),
                            ),
                            onPressed: () {
                              _setText("/");
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            fillColor: Colors.white,
                            child: Container(
                              child: Icon(Icons.backspace),
                            ),
                            onPressed: () {
                              _clearText();
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            fillColor: Colors.white,
                            child: Text(
                              "7".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.blueAccent),
                            ),
                            onPressed: () {
                              _setText("7");
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            fillColor: Colors.white,
                            child: Text(
                              "8".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.blueAccent),
                            ),
                            onPressed: () {
                              _setText("8");
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            fillColor: Colors.white,
                            child: Text(
                              "9".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.blueAccent),
                            ),
                            onPressed: () {
                              _setText("9");
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            fillColor: Colors.white,
                            child: Text(
                              "×".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.blueAccent),
                            ),
                            onPressed: () {
                              _setText("*");
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            fillColor: Colors.white,
                            child: Text(
                              "4".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.blueAccent),
                            ),
                            onPressed: () {
                              _setText("4");
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            fillColor: Colors.white,
                            child: Text(
                              "5".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.blueAccent),
                            ),
                            onPressed: () {
                              _setText("5");
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            fillColor: Colors.white,
                            child: Text(
                              "6".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.blueAccent),
                            ),
                            onPressed: () {
                              _setText("6");
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            fillColor: Colors.white,
                            child: Text(
                              "-".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.blueAccent),
                            ),
                            onPressed: () {
                              _setText("-");
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            fillColor: Colors.white,
                            child: Text(
                              "1".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.blueAccent),
                            ),
                            onPressed: () {
                              _setText("1");
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            fillColor: Colors.white,
                            child: Text(
                              "2".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.blueAccent),
                            ),
                            onPressed: () {
                              _setText("2");
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            fillColor: Colors.white,
                            child: Text(
                              "3".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.blueAccent),
                            ),
                            onPressed: () {
                              _setText("3");
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            fillColor: Colors.white,
                            child: Text(
                              "+".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.blueAccent),
                            ),
                            onPressed: () {
                              _setText("+");
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            fillColor: Colors.white,
                            child: Text(
                              ".".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.blueAccent),
                            ),
                            onPressed: () {
                              _setText(".");
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            fillColor: Colors.white,
                            child: Text(
                              "0".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.blueAccent),
                            ),
                            onPressed: () {
                              _setText("0");
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            fillColor: Colors.white,
                            child: Text(
                              " ".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.blueAccent),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          child: RawMaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            highlightElevation: 0,
                            focusElevation: 0,
                            disabledElevation: 0,
                            fillColor: Colors.blue,
                            child: Text(
                              "=".toUpperCase(),
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              callback.call(textController.text.toString());
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  void _setText(String text) {
    int start = max<int>(textController.selection.start, 0);
    int end = max<int>(textController.selection.end, 0);
    textController.text = textController.text.toString().substring(0, start) +
        text +
        textController.text
            .toString()
            .substring(end, textController.text.length);
    textController.selection = TextSelection.collapsed(offset: start + 1);
  }

  void _clearText() {
    int start = max<int>(textController.selection.start, 0);
    int end = max<int>(textController.selection.end, 0);
    start = start == end ? max<int>(start - 1, 0) : start;
    textController.text = textController.text.toString().substring(0, start) +
        textController.text
            .toString()
            .substring(end, textController.text.length);
    textController.selection = TextSelection.collapsed(offset: start);
  }
}
