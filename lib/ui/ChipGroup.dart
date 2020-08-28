import 'package:flutter/material.dart';

typedef void OnChipSelected(List<int> position);
typedef void OnChipCanceled(int index);

class ChipGroup extends StatefulWidget {
  int selectedIndex = -1;
  List<int> selectedIndexes = [];
  final List<String> chipTexts;
  OnChipSelected onChipSelectedCallback = (_) {};
  OnChipCanceled onChipCanceled = (_) {};
  List<int> chipColors = [];
  List<bool> cancelableIndexes = [];
  bool multipleSelectionEnabled = false;

  ChipGroup(this.chipTexts,
      {this.chipColors,
      this.onChipSelectedCallback,
      this.cancelableIndexes,
      this.selectedIndex,
      this.selectedIndexes,
      this.multipleSelectionEnabled,
      this.onChipCanceled});

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
      runSpacing: 3,
      children: List<Widget>.generate(
        widget.chipTexts.length,
        (int index) {
          List<Widget> row = [];
          if (widget.selectedIndex == index ||
              (widget.selectedIndexes != null &&
                  widget.selectedIndexes.contains(index))) {
            row.add(CircleAvatar(
              backgroundColor: Colors.black38,
              radius: 10,
              child: Icon(
                Icons.check,
                size: 12,
                color: Colors.white,
              ),
            ));
          }
          row.add(Container(
            margin: EdgeInsets.only(
                left: (widget.selectedIndex == index ||
                        (widget.selectedIndexes != null &&
                            widget.selectedIndexes.contains(index)))
                    ? 5
                    : 0),
            child: Text(
              '${widget.chipTexts[index]}',
              style: TextStyle(color: Colors.white),
            ),
          ));
          if (widget.cancelableIndexes != null &&
              widget.cancelableIndexes[index]) {
            row.add(Container(
              width: 18,
              margin: EdgeInsets.only(left: 7, right: 0),
              child: RawMaterialButton(
                fillColor: Colors.white,
                padding: EdgeInsets.all(0),
                shape: CircleBorder(),
                child: Container(
                  child: Icon(
                    Icons.close,
                    size: 12,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  widget.onChipCanceled.call(index);
                },
              ),
            ));
          }
          return GestureDetector(
            onTap: () {
              setState(() {
                if (widget.multipleSelectionEnabled == null ||
                    !widget.multipleSelectionEnabled) {
                  widget.selectedIndex = index;
                  widget.onChipSelectedCallback.call([index]);
                } else {
                  if (widget.selectedIndexes.contains(index)) {
                    widget.selectedIndexes.remove(index);
                  } else {
                    widget.selectedIndexes.add(index);
                  }
                  widget.onChipSelectedCallback(widget.selectedIndexes);
                }
              });
            },
            child: Wrap(
              children: <Widget>[
                Card(
                    color: Color(widget.chipColors[index]),
                    child: Container(
                      height: 30,
                      padding: EdgeInsets.only(
                          left: (widget.selectedIndex == index ||
                                  (widget.selectedIndexes != null &&
                                      widget.selectedIndexes.contains(index)))
                              ? 5
                              : 10,
                          right: 10,
                          top: 5,
                          bottom: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: row,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                    ))
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
