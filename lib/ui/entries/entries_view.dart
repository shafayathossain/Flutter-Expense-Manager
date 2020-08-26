import 'package:expense_manager/data/models/entry_list_item.dart';
import 'package:expense_manager/data/repositories/HomeRepositoryImpl.dart';
import 'package:expense_manager/ui/entries/entries_bloc.dart';
import 'package:expense_manager/ui/entries/entries_event.dart';
import 'package:expense_manager/ui/entries/entries_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EntriesView extends StatelessWidget {
  int startTime;
  int endTime;

  @override
  Widget build(BuildContext context) {
    List<int> argument = ModalRoute.of(context).settings.arguments;
    startTime = argument[0];
    endTime = argument[1];

    return BlocProvider(
      create: (context) => EntriesBloc(HomeRepositoryImpl(context)),
      child: Builder(
        builder: (contextB) {
          BlocProvider.of<EntriesBloc>(contextB)
              .add(GetEntriesEvent(startTime, endTime));
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Entries",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            backgroundColor: Color(0xFFE5EAEC),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          maxLines: 1,
                          onChanged: (text) {},
                          decoration: InputDecoration(
                              hintText: "Search here",
                              fillColor: Color(0xFFD3DADD),
                              filled: true,
                              hintStyle: TextStyle(color: Color(0xFF263238)),
                              errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.0))),
                              focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.0))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.0))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.0)))),
                        ),
                      ),
                      Container(
                        width: 60,
                        margin: EdgeInsets.only(left: 10),
                        child: RawMaterialButton(
                          onPressed: () {},
                          shape: CircleBorder(),
                          child: Icon(
                            Icons.filter_list,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    height: double.maxFinite,
                    child: BlocConsumer<EntriesBloc, EntriesState>(
                      listener: (context, state) {},
                      buildWhen: (context, state) => state is GetEntriesState,
                      builder: (context, state) {
                        return EntryListView(
                            (state as GetEntriesState).entries);
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class EntryListView extends StatefulWidget {
  List<EntryListItem> entries;
  int _selectedIndex = -1;

  EntryListView(this.entries);

  @override
  State createState() {
    return EntryListState();
  }
}

class EntryListState extends State<EntryListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.entries.length,
        itemBuilder: (context, index) {
          if (widget.entries[index].type == 1) {
            return Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
              child: Text(
                widget.entries[index].date,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
            );
          } else {
            return EntriesItemView(
                widget.entries[index], index, widget._selectedIndex, () {
              setState(() {
                widget._selectedIndex =
                    widget._selectedIndex == index ? -1 : index;
              });
            });
          }
        });
  }
}

typedef onItemClick();

class EntriesItemView extends StatefulWidget {
  final EntryListItem item;
  final onItemClick clickEvent;
  int selectedIndex = -1;
  int currentIndex;

  EntriesItemView(
      this.item, this.currentIndex, this.selectedIndex, this.clickEvent);

  @override
  State createState() {
    return EntriesItemState();
  }
}

class EntriesItemState extends State<EntriesItemView> {
  @override
  Widget build(BuildContext context) {
    List<Widget> firstChildren = [];
    List<Widget> lastRowChildren = [];
    List<Widget> parentChildren = [];

    parentChildren.add(Container(
      margin: EdgeInsets.all(15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: firstChildren)),
          Container(
            child: Text(
              widget.item.item.mEntry.amount.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ));
    if (widget.currentIndex == widget.selectedIndex) {
      parentChildren.add(Positioned.fill(
        child: Card(
          color: Colors.black45,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              OutlineButton(
                  child: new Text(
                    "Edit",
                    style: TextStyle(color: Colors.white),
                  ),
                  highlightedBorderColor: Colors.white,
                  disabledBorderColor: Colors.white,
                  onPressed: null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )),
              OutlineButton(
                  child: new Text(
                    "Delete",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: null,
                  highlightedBorderColor: Colors.white,
                  disabledBorderColor: Colors.white,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)))
            ],
          ),
        ),
      ));
    }

    firstChildren.add(Text(
      widget.item.item.mCategory.name,
      style: TextStyle(
          color: Color(widget.item.item.mCategory.color),
          fontSize: 16,
          fontWeight: FontWeight.bold),
    ));
    if (widget.item.item.mEntry.description != null &&
        widget.item.item.mEntry.description.length > 0) {
      firstChildren.add(Container(
        margin: EdgeInsets.only(top: 5, right: 10),
        child: Text(
          widget.item.item.mEntry.description,
          style: TextStyle(fontSize: 12, color: Colors.blueGrey),
        ),
      ));
    }

    lastRowChildren.addAll([
      Container(
        margin: EdgeInsets.only(top: 10),
        child: ImageIcon(
          AssetImage("assets/images/ic_wallet.png"),
          size: 15,
          color: Color(widget.item.item.mWallet.color),
        ),
      ),
      Container(
        margin: EdgeInsets.only(left: 10, top: 10, right: 10),
        child: Text(
          widget.item.item.mWallet.name,
          style: TextStyle(
              fontSize: 12, color: Color(widget.item.item.mWallet.color)),
        ),
      )
    ]);
    if (widget.item.item.mTag != null) {
      lastRowChildren.addAll([
        Container(
          margin: EdgeInsets.only(top: 10),
          child: ImageIcon(
            AssetImage("assets/images/ic_tag.png"),
            size: 15,
            color: Color(widget.item.item.mTag.color),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, top: 10, right: 10),
          child: Text(
            widget.item.item.mTag.name,
            style: TextStyle(
                fontSize: 12, color: Color(widget.item.item.mTag.color)),
          ),
        )
      ]);
    }
    firstChildren.add(Row(
      children: lastRowChildren,
    ));
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: GestureDetector(
        onTap: () {
          widget.clickEvent.call();
        },
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Stack(
            children: parentChildren,
          ),
        ),
      ),
    );
  }
}
