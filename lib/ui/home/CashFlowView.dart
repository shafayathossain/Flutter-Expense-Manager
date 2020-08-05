import 'package:expense_manager/data/repositories/HomeRepositoryImpl.dart';
import 'package:expense_manager/ui/home/DayRangeChip.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:expense_manager/ui/home/HomeBloc.dart';
import 'package:expense_manager/ui/home/HomeEvent.dart';
import 'package:expense_manager/ui/home/HomeState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CashFlowView extends StatefulWidget {
  @override
  State createState() {
    return _CashFlowState();
  }
}

class _CashFlowState extends State<CashFlowView> {
  String _customChipName = "Custom";
  int _selectedPosition = 0;
  ScrollController _scrollController = ScrollController();
  GlobalKey _dateRangeListViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    /* return BlocBuilder(
        bloc: BlocProvider.of<HomeBloc>(context),
        builder: (context, state) {
          if (!(state is ResetState || state is InitState)) {
            BlocProvider.of<HomeBloc>(context).add(ResetEvent());
          }*/
    return Container(
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(left: 10, top: 10, right: 10),
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                key: _dateRangeListViewKey,
                children: [
                  DayRangeChipGroup(
                    [
                      "This month",
                      "Last month",
                      "This year",
                      "Last year",
                      _customChipName
                    ],
                    selectedIndex: _selectedPosition,
                    onChipSelectedCallback: (index) {
                      print(index);
                      _selectedPosition = index;
//                      BlocProvider.of<HomeBloc>(context).add(InitialEvent());
                      BlocProvider.of<HomeBloc>(context)
                          .add(GetThisMonthBalanceEvent(
                        DateTime(DateTime.now().year, DateTime.now().month, 1)
                            .millisecondsSinceEpoch,
                        DateTime(DateTime.now().year, DateTime.now().month + 1,
                                1)
                            .subtract(Duration(days: index))
                            .millisecondsSinceEpoch,
                      ));
                      if (index == 4) {
                        _showDatePickerDialog();
                      } else {
                        if (_customChipName != "Custom") {
                          setState(() {
                            _customChipName = "Custom";
                          });
                        }
                      }
                    },
                  ),
                ],
              )),
          Container(
              margin: EdgeInsets.only(left: 10, top: 10, right: 10),
              height: 300,
              child:
                  BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                if (state is CashFlowState) {
                  List<charts.Series<double, String>> series = [
                    charts.Series(
                        data: state.data,
                        domainFn: (_, index) =>
                            index == 0 ? "Income" : "Expense",
                        measureFn: (_, index) => state.data[index],
                        labelAccessorFn: (_, index) => "${state.data[index]}",
                        colorFn: (_, index) => index == 0
                            ? charts.Color(
                                r: Colors.blue.red,
                                g: Colors.blue.green,
                                b: Colors.blue.blue)
                            : charts.Color(
                                r: Colors.red.red,
                                g: Colors.red.green,
                                b: Colors.red.blue),
                        id: "Balance")
                  ];
                  return charts.BarChart(
                    series,
                    domainAxis: charts.OrdinalAxisSpec(),
                    primaryMeasureAxis: new charts.NumericAxisSpec(
                        tickProviderSpec: charts.BasicNumericTickProviderSpec(
                            desiredTickCount: 3),
                        renderSpec: charts.GridlineRendererSpec(
                            labelJustification:
                                charts.TickLabelJustification.outside,
                            axisLineStyle: charts.LineStyleSpec(
                                color: charts.Color(
                                    r: Colors.blueGrey.red,
                                    g: Colors.blueGrey.green,
                                    b: Colors.blueGrey.blue)))),
                    secondaryMeasureAxis: new charts.NumericAxisSpec(
                        tickProviderSpec:
                            new charts.BasicNumericTickProviderSpec(
                                desiredTickCount: 3),
                        renderSpec: charts.GridlineRendererSpec(
                            labelJustification:
                                charts.TickLabelJustification.outside,
                            axisLineStyle: charts.LineStyleSpec(
                                color: charts.Color(
                                    r: Colors.blueGrey.red,
                                    g: Colors.blueGrey.green,
                                    b: Colors.blueGrey.blue)))),
                  );
                } else
                  return Container();
              })),
        ],
      ),
    );
  }

  void _showDatePickerDialog() async {
    final List<DateTime> pickedDates = await DateRagePicker.showDatePicker(
      context: context,
      initialFirstDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
      initialLastDate:
          DateTime(DateTime.now().year, DateTime.now().month + 1, 1)
              .subtract(Duration(days: 1)),
      firstDate: new DateTime(2010),
      lastDate: new DateTime(2030),
    );
    if (pickedDates != null) {
      print(pickedDates);
      if (pickedDates.length == 2) {
        final formatter = DateFormat("dd-MM-yyyy");
        final dateString =
            "${formatter.format(pickedDates[0])} to ${formatter.format(pickedDates[1])}";
        setState(() {
          _customChipName = dateString;
          _scrollToPosition(5);
        });
      }
    }
  }

  void _scrollToPosition(int index) {
    final position =
        _dateRangeListViewKey.currentContext.size.width * index / 5;
    _scrollController.animateTo(position,
        curve: Curves.ease, duration: Duration(microseconds: 1000));
  }
}
