import 'package:flutter/material.dart';

typedef void OnChipSelected(int position);

class ChipGroup extends StatefulWidget {

  int _selectedIndex = -1;
  final List<String> chipTexts;
  OnChipSelected onChipSelectedCallback = (_){};
  List<int> chipColors = [];

  ChipGroup(this.chipTexts, {this.chipColors, this.onChipSelectedCallback}){
  }

  @override
  State createState() {
    return ChipGroupState();
  }
}

class ChipGroupState extends State<ChipGroup> {

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
          return FilterChip(
            label: Text(
              '${widget.chipTexts[index]}',
              style: TextStyle(color: Colors.white),
            ),
            selected: widget._selectedIndex == index,
            checkmarkColor: Colors.white,
            showCheckmark: true,
            selectedColor: widget.chipColors != null && index < widget.chipColors.length ? Color(widget.chipColors[index]) : Colors.pink,
            backgroundColor: widget.chipColors != null && index < widget.chipColors.length ? Color(widget.chipColors[index]) : Colors.pink,
            avatar: widget._selectedIndex == index ? CircleAvatar( backgroundColor: Colors.black38,) : null,
            onSelected: (bool selected) {
              setState(() {
                widget._selectedIndex = index;
                widget.onChipSelectedCallback.call(index);
              });
            },
          );
        },
      ).toList(),
    );
  }
}