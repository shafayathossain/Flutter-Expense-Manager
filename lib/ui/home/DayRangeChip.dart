import 'package:flutter/material.dart';

typedef void OnChipSelected(int position);

class DayRangeChipGroup extends StatefulWidget {

  int selectedIndex = 0;
  final List<String> chipTexts;
  OnChipSelected onChipSelectedCallback = (_){};
  List<int> chipColors = [];

  DayRangeChipGroup(this.chipTexts, {this.chipColors, this.onChipSelectedCallback, this.selectedIndex}){}

  @override
  State createState() {
    return DayRangeChipGroupState();
  }
}

class DayRangeChipGroupState extends State<DayRangeChipGroup> {

//  int selectedIndex = -1;
//  final List<String> chipTexts;
//  List<int> chipColors = [];


  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: List<Widget>.generate(
        widget.chipTexts.length,
            (int index) {
          return ChoiceChip(
            label: Text(
              '${widget.chipTexts[index]}',
              style: TextStyle(
                color: widget.selectedIndex == index ? Colors.white : Colors.black
              ),
            ),
            selected: widget.selectedIndex == index,
            selectedColor: Colors.blue,
            backgroundColor: Colors.white,
            onSelected: (bool selected) {
              setState(() {
                widget.selectedIndex = index;
                if(widget.onChipSelectedCallback != null) {
                  widget.onChipSelectedCallback.call(index);
                }
              });
            },
          );
        },
      ).toList(),
    );
  }
}