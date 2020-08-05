import 'package:expense_manager/data/models/CashFlowOfDay.dart';
import 'package:expense_manager/data/models/ExpenseOfCategory.dart';
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
import 'package:mp_chart/mp/chart/bar_chart.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/chart/pie_chart.dart';
import 'package:mp_chart/mp/controller/bar_chart_controller.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/controller/pie_chart_controller.dart';
import 'package:mp_chart/mp/core/adapter_android_mp.dart';
import 'package:mp_chart/mp/core/axis/y_axis.dart';
import 'package:mp_chart/mp/core/data/bar_data.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data/pie_data.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_bar_data_set.dart';
import 'package:mp_chart/mp/core/data_set/bar_data_set.dart';
import 'package:mp_chart/mp/core/data_set/data_set.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/data_set/pie_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/bar_entry.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/entry/pie_entry.dart';
import 'package:mp_chart/mp/core/enums/axis_dependency.dart';
import 'package:mp_chart/mp/core/enums/mode.dart';
import 'package:mp_chart/mp/core/enums/value_position.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';
import 'package:mp_chart/mp/core/value_formatter/value_formatter.dart';
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
    return BlocBuilder(
        bloc: BlocProvider.of<HomeBloc>(context),
        builder: (context, state) {
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
                            BlocProvider.of<HomeBloc>(context).add(
                                GetThisMonthBalanceEvent(
                                  DateTime(DateTime
                                      .now()
                                      .year, DateTime
                                      .now()
                                      .month, 1).millisecondsSinceEpoch,
                                  DateTime(DateTime
                                      .now()
                                      .year, DateTime
                                      .now()
                                      .month + 1, 1)
                                      .subtract(Duration(days: index))
                                      .millisecondsSinceEpoch,
                                ));
                            BlocProvider.of<HomeBloc>(context).add(
                                GetExpensesOfCategory(
                                  DateTime(DateTime
                                      .now()
                                      .year, DateTime
                                      .now()
                                      .month, 1).millisecondsSinceEpoch,
                                  DateTime(DateTime
                                      .now()
                                      .year, DateTime
                                      .now()
                                      .month + 1, 1)
                                      .subtract(Duration(days: index))
                                      .millisecondsSinceEpoch,
                                ));
                            if (index == 4) {
                              _showDatePickerDialog();
                            } else {
                              if (_customChipName != "Custom") {
                                print("Set state");
                                setState(() {
                                  _customChipName = "Custom";
                                });
                              }
                            }
                          },
                        ),
                      ],
                    )
                ),
                Container(
                  height: 330,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      children: <Widget>[
                        StreamBuilder(
                          stream: BlocProvider
                              .of<HomeBloc>(context)
                              .incomeAndExpenses,

                          builder: (context, AsyncSnapshot<List<double>> snapshot) {

                            List<BarEntry> entries = List();
                            if(snapshot.data != null) {
                              snapshot.data.forEach((element) {
                                entries.add(
                                    BarEntry(x: snapshot.data.indexOf(element)
                                        .toDouble(), y: element)
                                );
                              });
                            }
                            IBarDataSet dataSet = BarDataSet( entries, "")..setColors1([Colors.green, Colors.red]);
                            BarData data = BarData([dataSet]);
                            data.setValueTextSize(10.0);
                            BarChartController controller = BarChartController(
                              axisLeftSettingFunction: (axisLeft, controller) {
                                axisLeft.drawGridLines = false;
                                axisLeft.setAxisMinimum(0.0);
                              },
                              axisRightSettingFunction: (axisRight, controller) {
                                axisRight.drawGridLines = false;
                                axisRight.enabled = false;
                              },
                              legendSettingFunction: (legend, controller) {
                                legend.enabled = false;
                              },
                              xAxisSettingFunction: (xAxis, controller) {
                                xAxis
                                  ..position = XAxisPosition.BOTTOM
                                  ..drawGridLines = false
                                  ..setGranularity(1.0);
                                xAxis.setValueFormatter(MyValueFormatter());
                              },
                              drawGridBackground: false,
                              description: (Description()..enabled = false),
                              fitBars: true,
                            );
                            controller.data = data;
                            return Container(
                                margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                                width: 300,
                                height: 320,
                                child: Card(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                                        child: Text(
                                          "Balance",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 240,
                                        child: BarChart(controller),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10, top: 0, right: 10),
                                        child: Text(
                                          "Total balance:   ${snapshot.data != null ? snapshot.data[0] - snapshot.data[1] : 0.0}",
                                          style: TextStyle(
                                              fontSize: 16
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            );
                          },
                        ),
                        StreamBuilder(
                          stream: BlocProvider
                              .of<HomeBloc>(context)
                              .expenses,
                          builder: (context, AsyncSnapshot<List<ExpenseOfCategory>> snapshot) {

                            List<PieEntry> entries = [];
                            List<Color> colors = [];
                            double total = 0.0;
                            if(snapshot.data != null) {
                              snapshot.data.forEach((element) {
                                total += element.total.abs();
                                entries.add(
                                    PieEntry(
                                        value: element.total.abs(),
                                        label: element.name
                                    )
                                );
                                colors.add(Color(element.color));
                              });
                            }
                            final dataSet = PieDataSet(entries, "");
                            dataSet.setColors1(colors);
                            dataSet.setValueTextColor(Colors.white);
                            dataSet.setXValuePosition(ValuePosition.OUTSIDE_SLICE);
                            dataSet.setValueLineColor(Colors.black);
                            dataSet.setValueTextSize(10.0);
                            final controller = PieChartController(
                                legendSettingFunction: (legend, controller) {
                                  legend.enabled = false;
                                },
                                description: Description()..enabled = false,
                                centerTextTypeface: TypeFace()..fontWeight = FontWeight.bold,
                                extraBottomOffset: 2,
                                extraTopOffset: 2,
                                holeRadiusPercent: 17,
                                centerText: "Total/n${total}"
                            );
                            controller.data = PieData(dataSet);
                            return Container(
                                margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                                width: 300,
                                height: 320,
                                child: Card(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                                        child: Text(
                                          "Expenses",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 250,
                                        child: PieChart(controller),
                                      )
                                    ],
                                  ),
                                )
                            );
                          },
                        ),
                        StreamBuilder(
                          stream: BlocProvider
                              .of<HomeBloc>(context)
                              .cashFlowData,
                          builder: (context, AsyncSnapshot<List<CashFlowOfDay>> snapshot) {
                            print(snapshot);
                            if(snapshot.connectionState == ConnectionState.waiting) {
                              return Container(
                                  margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                                  width: 300,
                                  height: 320,
                                  child: Card()
                              );
                            }
                            List<Entry> entries = [];
                            if(snapshot.data != null) {
                              snapshot.data.forEach((element) {
                                entries.add(
                                    Entry(
                                        x: snapshot.data.indexOf(element)
                                            .toDouble(),
                                        y: element.balance
                                    )
                                );
                              });
                            }
                            LineDataSet dataSet = LineDataSet(entries, "")
                              ..setDrawCircles(false)
                              ..setMode(Mode.HORIZONTAL_BEZIER)
                              ..setDrawFilled(true)
                              ..setDrawValues(false)
                              ..setGradientFilled(true)
                              ..setGradientColor(Color(0x007AC1), Color(0xFF0000));

                            final controller = LineChartController(
                                xAxisSettingFunction: (xAxis, controller) {
                                  xAxis.drawGridLinesBehindData = true;
                                  xAxis.drawLabels = false;
                                  xAxis.enabled = false;
                                },
                                axisLeftSettingFunction: (axisLeft, controller) {
                                  axisLeft.drawLabels = true;
                                  axisLeft.drawGridLines = true;
                                  axisLeft.enabled = true;
                                },
                                axisRightSettingFunction: (axisRight, controller) {
                                  axisRight.drawLabels = false;
                                  axisRight.drawGridLines = false;
                                  axisRight.enabled = false;
                                },
                                legendSettingFunction: (legend, controller) {
                                  legend.enabled = false;
                                },

                                description: Description()..enabled = false
                            );
                            controller.data = LineData()..addDataSet(dataSet);
                            return Container(
                                margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                                width: 300,
                                height: 320,
                                child: Card(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                                        child: Text(
                                          "Income and expenditure flow",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 260,
                                        child: LineChart(controller),
                                      )
                                    ],
                                  ),
                                )
                            );
                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
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

class MyValueFormatter extends ValueFormatter {


  @override
  String getFormattedValue1(double value) {
    if(value == 0) {
      return "Income";
    } else if(value == 1) {
      return "Expense";
    } else {
      return "Others";
    }
  }
}
