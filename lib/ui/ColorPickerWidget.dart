import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<int> colors = [
    0xFFEF5350, 0xFFF44336,0xFFE53935,0xFFD32F2F,0xFFC62828,0xFFB71C1C, 0xFFFF5252, 0xFFFF1744,
    0xFFD50000, 0xFF7E57C2,0xFF673AB7,0xFF5E35B1,0xFF512DA8,0xFF4527A0,0xFF311B92, 0xFF651FFF, 0xFF6200EA,
    0xFF03A9F4,0xFF039BE5,0xFF0288D1,0xFF0277BD,0xFF01579B, 0xFF4CAF50,0xFF43A047,0xFF388E3C,0xFF2E7D32,
    0xFF1B5E20, 0xFF00C853, 0xFFFF5722,0xFFF4511E,0xFFE64A19,0xFFD84315,0xFFBF360C, 0xFFFF6E40,
    0xFFFF3D00,0xFFDD2C00, 0xFF607D8B,0xFF546E7A,0xFF455A64,0xFF37474F,0xFF263238, 0xFFE91E63,0xFFD81B60,
    0xFFC2185B,0xFFAD1457,0xFF880E4F, 0xFFFF4081,0xFFF50057,0xFFC51162, 0xFF3F51B5,0xFF3949AB,0xFF303F9F,
    0xFF283593,0xFF1A237E, 0xFF3D5AFE, 0xFF304FFE, 0xFF0097A7,0xFF00838F,0xFF006064, 0xFF689F38,
    0xFF558B2F,0xFF33691E, 0xFFFF6F00, 0xFF795548,0xFF6D4C41,0xFF5D4037,0xFF4E342E,0xFF3E2723,
    0xFF9C27B0,0xFF8E24AA,0xFF7B1FA2,0xFF6A1B9A,0xFF4A148C, 0xFFD500F9, 0xFFAA00FF, 0xFF1976D2,
    0xFF1565C0,0xFF0D47A1, 0xFF2979FF, 0xFF2962FF, 0xFF009688,0xFF00897B,0xFF00796B,0xFF00695C,
    0xFF004D40, 0xFF827717, 0xFFEF6C00, 0xFFE65100, 0xFFFF6D00, 0xFF616161,0xFF424242,0xFF212121
];

typedef void ColorPickerWidgetCallback(int color);

class ColorPickerWidget extends StatefulWidget {

  ColorPickerWidgetCallback callback;
  int selectedItem = -1;

  ColorPickerWidget({this.callback});

  @override
  State createState() {
    return ColorPickerState(
      colorPickCallback: (int color, int position) {
        selectedItem = position;
        callback.call(colors[position]);
      }
    );
  }
}

typedef void ColorPickCallback(int color, int position);

class ColorPickerState extends State<ColorPickerWidget> {

  int selectedItem = -1;
  ColorPickCallback colorPickCallback;

  ColorPickerState({this.colorPickCallback});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 6,
      childAspectRatio: .8,
      children: List.generate(
        colors.length, (index) {
          return ColorPickerItemBuilder(
            selectedItem: selectedItem,
            position: index,
            callback: (int color, int position) {
              selectedItem = position;
              colorPickCallback.call(color, position);
              setState((){});
            },
          );
        }
      ),
    );
  }
}

class ColorPickerItemBuilder extends StatelessWidget {

  int selectedItem = -1;
  int position = -1;
  ColorPickCallback callback;

  ColorPickerItemBuilder({this.selectedItem, this.position, this.callback});

 @override
  Widget build(BuildContext context) {
    if(selectedItem == position) {
      return Container(
        height: 10.0,
        width: 10.0,
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child:  MaterialButton(
          shape: CircleBorder(side: BorderSide(width: 2, color: Color(colors[position]), style: BorderStyle.solid)),
          color: Color(colors[position]),
          padding: EdgeInsets.all(0),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 20,
          ),
          onPressed: (){
            callback.call(colors[position], position);
          },
        ),
      );
    } else {
      return Container(
        height: 10.0,
        width: 10.0,
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: MaterialButton(
          shape: CircleBorder(side: BorderSide(width: 2, color: Color(colors[position]), style: BorderStyle.solid)),
          color: Color(colors[position]),
          onPressed: (){
            callback.call(colors[position], position);
          },
        ),
      );
    }
  }
}