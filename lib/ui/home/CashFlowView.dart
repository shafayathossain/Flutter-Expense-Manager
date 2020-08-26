import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:expense_manager/data/models/CashFlowOfDay.dart';
import 'package:expense_manager/data/models/ExpenseOfCategory.dart';
import 'package:expense_manager/ui/Router.dart';
import 'package:expense_manager/ui/home/DayRangeChip.dart';
import 'package:expense_manager/ui/home/HomeBloc.dart';
import 'package:expense_manager/ui/home/HomeEvent.dart';
import 'package:expense_manager/ui/home/HomeState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mp_chart/mp/chart/bar_chart.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/chart/pie_chart.dart';
import 'package:mp_chart/mp/controller/bar_chart_controller.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/controller/pie_chart_controller.dart';
import 'package:mp_chart/mp/core/adapter_android_mp.dart';
import 'package:mp_chart/mp/core/data/bar_data.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data/pie_data.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_bar_data_set.dart';
import 'package:mp_chart/mp/core/data_set/bar_data_set.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/data_set/pie_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/bar_entry.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/entry/pie_entry.dart';
import 'package:mp_chart/mp/core/enums/legend_horizontal_alignment.dart';
import 'package:mp_chart/mp/core/enums/legend_orientation.dart';
import 'package:mp_chart/mp/core/enums/legend_vertical_alignment.dart';
import 'package:mp_chart/mp/core/enums/mode.dart';
import 'package:mp_chart/mp/core/enums/value_position.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';
import 'package:mp_chart/mp/core/enums/y_axis_label_position.dart';
import 'package:mp_chart/mp/core/render/pie_chart_renderer.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';
import 'package:mp_chart/mp/core/value_formatter/value_formatter.dart';

class CashFlowView extends StatefulWidget {
  int startTime = DateTime(DateTime.now().year, DateTime.now().month, 1)
      .millisecondsSinceEpoch;
  int endTime = DateTime(DateTime.now().year, DateTime.now().month + 1, 1)
      .subtract(Duration(days: 1))
      .millisecondsSinceEpoch;

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
    return Column(
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
                    _selectedPosition = index;
                    if (index == 0) {
                      widget.startTime =
                          DateTime(DateTime.now().year, DateTime.now().month, 1)
                              .millisecondsSinceEpoch;
                      widget.endTime = DateTime(
                              DateTime.now().year, DateTime.now().month + 1, 1)
                          .subtract(Duration(days: 1))
                          .millisecondsSinceEpoch;
                      BlocProvider.of<HomeBloc>(context).add(
                          GetBalanceEvent(widget.startTime, widget.endTime));
                    } else if (index == 1) {
                      BlocProvider.of<HomeBloc>(context).add(GetBalanceEvent(
                        DateTime(DateTime.now().year, DateTime.now().month - 1,
                                1)
                            .millisecondsSinceEpoch,
                        DateTime(DateTime.now().year, DateTime.now().month, 1)
                            .subtract(Duration(days: 1))
                            .millisecondsSinceEpoch,
                      ));
                    } else if (index == 2) {
                      widget.startTime = DateTime(DateTime.now().year, 1, 1)
                          .millisecondsSinceEpoch;
                      widget.endTime = DateTime(DateTime.now().year + 1, 1, 1)
                          .subtract(Duration(days: 1))
                          .millisecondsSinceEpoch;
                      BlocProvider.of<HomeBloc>(context).add(
                          GetBalanceEvent(widget.startTime, widget.endTime));
                    } else if (index == 3) {
                      widget.startTime = DateTime(DateTime.now().year - 1, 1, 1)
                          .millisecondsSinceEpoch;
                      widget.endTime = DateTime(DateTime.now().year, 1, 1)
                          .subtract(Duration(days: 1))
                          .millisecondsSinceEpoch;
                      BlocProvider.of<HomeBloc>(context).add(
                          GetBalanceEvent(widget.startTime, widget.endTime));
                    }
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
          height: 340,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              children: <Widget>[
                StreamBuilder(
                  stream: BlocProvider.of<HomeBloc>(context).incomeAndExpenses,
                  builder: (context, AsyncSnapshot<List<double>> snapshot) {
                    List<BarEntry> entries = List();
                    if (snapshot.data != null) {
                      snapshot.data.forEach((element) {
                        entries.add(BarEntry(
                            x: snapshot.data.indexOf(element).toDouble(),
                            y: element));
                      });
                    }
                    IBarDataSet dataSet = BarDataSet(entries, "")
                      ..setColors1([Colors.green, Colors.red]);
                    BarData data = BarData([dataSet]);
                    data.setValueTextSize(10.0);
                    BarChartController controller = BarChartController(
                      axisLeftSettingFunction: (axisLeft, controller) {
                        axisLeft.drawGridLines = false;
                        axisLeft.setAxisMinimum(0.0);
                        axisLeft.position = YAxisLabelPosition.OUTSIDE_CHART;
                        axisLeft.spacePercentTop = 15;
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
                      drawValueAboveBar: true,
                      description: (Description()..enabled = false),
                      fitBars: true,
                    );
                    controller.data = data;
                    return Container(
                        margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                        width: 300,
                        height: 330,
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, top: 10, right: 10),
                                child: Text(
                                  "Balance",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                height: 240,
                                child: BarChart(controller),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, top: 0, right: 10),
                                child: Text(
                                  "Total balance:   ${snapshot.data != null ? snapshot.data[0] - snapshot.data[1] : 0.0}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ));
                  },
                ),
                StreamBuilder(
                  stream: BlocProvider.of<HomeBloc>(context).expenses,
                  builder: (context,
                      AsyncSnapshot<List<ExpenseOfCategory>> snapshot) {
                    List<PieEntry> entries = [];
                    List<Color> colors = [];
                    double total = 0.0;
                    if (snapshot.data != null) {
                      snapshot.data.forEach((element) {
                        total += element.total.abs();
                        entries.add(PieEntry(
                          value: element.total.abs(),
                          label: element.name,
                        ));
                        colors.add(Color(element.color));
                      });
                    }
                    final dataSet = PieDataSet(entries, "");
                    dataSet.setColors1(colors);
                    dataSet.setValueTextColor(Colors.white);
                    dataSet.setXValuePosition(ValuePosition.INSIDE_SLICE);
                    dataSet.setYValuePosition(ValuePosition.OUTSIDE_SLICE);
                    dataSet.setSelectionShift(0);
                    dataSet.setValueLineColor(Colors.black);
                    dataSet.setValueTextSize(10.0);
                    dataSet.setValueLinePart1Length(.5);
                    dataSet.setValueLinePart2Length(.2);
                    dataSet.setValueLinePart1OffsetPercentage(80.0);
                    final controller = PieChartController(
                      legendSettingFunction: (legend, controller) {
                        legend
                          ..verticalAlignment = (LegendVerticalAlignment.TOP)
                          ..horizontalAlignment =
                              (LegendHorizontalAlignment.RIGHT)
                          ..orientation = (LegendOrientation.VERTICAL)
                          ..drawInside = (false)
                          ..enabled = (false);
                      },
                      rendererSettingFunction: (renderer) {
                        (renderer as PieChartRenderer)
                          ..setHoleColor(ColorUtils.WHITE)
                          ..setHoleColor(ColorUtils.WHITE)
                          ..setTransparentCircleColor(ColorUtils.WHITE)
                          ..setTransparentCircleAlpha(110);
                      },
                      description: Description()..enabled = false,
                      centerTextTypeface: TypeFace()
                        ..fontWeight = FontWeight.bold,
                      transparentCircleRadiusPercent: 50,
                      extraBottomOffset: 1,
                      extraTopOffset: 1,
                      holeRadiusPercent: 50,
                      rotateEnabled: true,
                      centerText: "Total\n${total}",
                    );
                    controller.data = PieData(dataSet)
                      ..setValueTextColor(Colors.black);
                    return Container(
                        margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                        width: 300,
                        height: 330,
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, top: 10, right: 10),
                                child: Text(
                                  "Expenses",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                height: 270,
                                child: PieChart(controller),
                              )
                            ],
                          ),
                        ));
                  },
                ),
                StreamBuilder(
                  stream: BlocProvider.of<HomeBloc>(context).cashFlowData,
                  builder:
                      (context, AsyncSnapshot<List<CashFlowOfDay>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                          margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                          width: 300,
                          height: 330,
                          child: Card());
                    }
                    List<Entry> entries = [];
                    if (snapshot.data != null) {
                      snapshot.data.forEach((element) {
                        entries.add(Entry(
                            x: snapshot.data.indexOf(element).toDouble(),
                            y: element.balance));
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
                        description: Description()..enabled = false);
                    controller.data = LineData()..addDataSet(dataSet);
                    return Container(
                        margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                        width: 300,
                        height: 330,
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, top: 10, right: 10),
                                child: Text(
                                  "Income and expenditure flow",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                height: 260,
                                child: LineChart(controller),
                              )
                            ],
                          ),
                        ));
                  },
                )
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: Card(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 5),
                      child: Text(
                        "Entries",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10, top: 5),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        color: Colors.blueAccent,
                        highlightColor: Colors.blueAccent,
                        splashColor: Colors.white60,
                        onPressed: () {
                          Navigator.pushNamed(context, EntriesRoute,
                              arguments: [widget.startTime, widget.endTime]);
                        },
                        child: Text(
                          "See all",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: BlocConsumer(
                          listener: (context, state) {},
                          bloc: BlocProvider.of<HomeBloc>(context),
                          buildWhen: (contet, state) =>
                              state is TopFiveEntriesState,
                          builder: (context, state) {
                            print("476 - $state");
                            if (state is TopFiveEntriesState &&
                                state.entries.length > 0) {
                              final formatter = DateFormat("dd-MM-yyyy");
                              return Column(
                                children: List.generate(state.entries.length,
                                    (index) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.max,
                                    key: UniqueKey(),
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Expanded(
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        Column(
                                                          children: <Widget>[
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                CircleAvatar(
                                                                  radius: 20,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        state
                                                                            .entries[index]
                                                                            .mCategory
                                                                            .name,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        formatter.format(DateTime.fromMillisecondsSinceEpoch(state
                                                                            .entries[index]
                                                                            .mEntry
                                                                            .date)),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        Text(
                                                          state.entries[index]
                                                              .mEntry.amount
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                }),
                              );
                            } else if (state is TopFiveEntriesState) {
                              return Container(
                                height: 50,
                                alignment: Alignment.center,
                                child: Text("No entries created"),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
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
      if (pickedDates.length == 2) {
        final formatter = DateFormat("dd-MM-yyyy");
        final dateString =
            "${formatter.format(pickedDates[0])} to ${formatter.format(pickedDates[1])}";

        setState(() {
          _customChipName = dateString;
          _scrollToPosition(5);
          widget.startTime = pickedDates[0].millisecondsSinceEpoch;
          widget.endTime = pickedDates[1].millisecondsSinceEpoch;
          BlocProvider.of<HomeBloc>(context)
              .add(GetBalanceEvent(widget.startTime, widget.endTime));
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
    if (value == 0) {
      return "Income";
    } else if (value == 1) {
      return "Expense";
    } else {
      return "Others";
    }
  }
}
