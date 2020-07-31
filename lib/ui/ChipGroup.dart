import 'package:flutter/material.dart';

class ChipGroup extends StatefulWidget {

  final int _selectedIndex = -1;
  final List<String> chipTexts;
  List<int> chipColors = [];

  ChipGroup({this.chipTexts, this.chipColors});

  @override
  State createState() {
    return ChipGroupState(
      chipTexts: chipTexts,
      chipColors: chipColors,
      selectedIndex: _selectedIndex
    );
  }
}

class ChipGroupState extends State<ChipGroup> {

  int selectedIndex = -1;
  final List<String> chipTexts;
  List<int> chipColors = [];

  ChipGroupState({this.chipTexts, this.chipColors, this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: List<Widget>.generate(
        chipTexts.length,
        (int index) {
          return FilterChip(
            label: Text(
              '${chipTexts[index]}',
              style: TextStyle(color: Colors.white),
            ),
            selected: selectedIndex == index,
            checkmarkColor: Colors.white,
            selectedColor: chipColors != null && index < chipColors.length ? Color(chipColors[0]) : Colors.pink,
            backgroundColor: chipColors != null && index < chipColors.length ? Color(chipColors[0]) : Colors.pink,
            avatar: selectedIndex == index ? CircleAvatar( backgroundColor: Colors.black38,) : null,
            onSelected: (bool selected) {
              setState(() {
                selectedIndex = index;
              });
            },
          );
        },
      ).toList(),
    );
  }
}