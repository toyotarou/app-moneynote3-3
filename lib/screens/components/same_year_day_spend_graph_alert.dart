import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../extensions/extensions.dart';

class SameYearDaySpendGraphAlert extends ConsumerStatefulWidget {
  const SameYearDaySpendGraphAlert({
    super.key,
    required this.yearList,
    required this.graphData,
  });

  final List<String> yearList;
  final Map<String, Map<String, int>> graphData;

  @override
  ConsumerState<SameYearDaySpendGraphAlert> createState() => _SameYearDaySpendGraphAlertState();
}

class _SameYearDaySpendGraphAlertState extends ConsumerState<SameYearDaySpendGraphAlert> {
  String selectedYear = '';

  LineChartData graphData = LineChartData();
  LineChartData graphData2 = LineChartData();

  List<FlSpot> _flspots = <FlSpot>[];

  int graphMin = 0;
  int graphMax = 0;

  ///
  @override
  void initState() {
    super.initState();

    selectedYear = widget.yearList[0];
  }

  ///
  @override
  Widget build(BuildContext context) {
    _setChartData();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DefaultTextStyle(
          style: GoogleFonts.kiwiMaru(fontSize: 12),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(height: 10),
                  Expanded(child: LineChart(graphData2)),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(height: 10),
                  Expanded(child: LineChart(graphData)),
                ],
              ),
              Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  const Text('年別収支金額'),
                  Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                  Container(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      height: 50,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: widget.yearList.map(
                            (String e) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: GestureDetector(
                                  onTap: () => setState(() => selectedYear = e),
                                  child: CircleAvatar(
                                    backgroundColor: (selectedYear == e)
                                        ? Colors.yellowAccent.withOpacity(0.2)
                                        : Colors.white.withOpacity(0.2),
                                    child: Text(e, style: const TextStyle(fontSize: 12, color: Colors.black)),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void _setChartData() {
    _flspots = <FlSpot>[];

    int i = 0;
    final List<int> list = <int>[];
    widget.graphData[selectedYear]?.forEach((String key, int value) {
      _flspots.add(FlSpot((i + 1).toDouble(), value.toDouble()));

      list.add(value);

      i++;
    });

    const int warisuu = 500000;
    final int minValue = list.reduce(min);
    final int maxValue = list.reduce(max);

    graphMin = ((minValue / warisuu).floor()) * warisuu;
    graphMax = ((maxValue / warisuu).ceil()) * warisuu;

    graphData = LineChartData(
      ///
      minX: 1,
      maxX: _flspots.length.toDouble(),
      //
      minY: graphMin.toDouble(),
      maxY: graphMax.toDouble(),

      ///
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 2,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              final List<LineTooltipItem> list = <LineTooltipItem>[];

              for (final LineBarSpot element in touchedSpots) {
                final TextStyle textStyle = TextStyle(
                  color: element.bar.gradient?.colors.first ?? element.bar.color ?? Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );

                final String price = element.y.round().toString().split('.')[0].toCurrency();

                final String day = DateTime(selectedYear.toInt()).add(Duration(days: element.x.toInt() - 1)).yyyymmdd;

                list.add(
                  LineTooltipItem(
                    '$day\n$price',
                    textStyle,
                    textAlign: TextAlign.end,
                  ),
                );
              }

              return list;
            }),
      ),

      ///
      titlesData: const FlTitlesData(show: false),

      ///
      borderData: FlBorderData(show: false),

      ///
      lineBarsData: <LineChartBarData>[
        LineChartBarData(
          spots: _flspots,
          color: Colors.yellowAccent,
          dotData: const FlDotData(show: false),
          barWidth: 1,
        ),
      ],
    );

    graphData2 = LineChartData(
      ///
      minX: 1,
      maxX: _flspots.length.toDouble(),
      //
      minY: graphMin.toDouble(),
      maxY: graphMax.toDouble(),

      borderData: FlBorderData(show: false),

      ///
      lineTouchData: const LineTouchData(enabled: false),

      ///
      gridData: const FlGridData(show: false),

      ///
      titlesData: FlTitlesData(
        //-------------------------// 上部の目盛り
        topTitles: const AxisTitles(),
        //-------------------------// 上部の目盛り

        //-------------------------// 下部の目盛り
        bottomTitles: const AxisTitles(),
        //-------------------------// 下部の目盛り

        //-------------------------// 左側の目盛り
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 70,
            getTitlesWidget: (double value, TitleMeta meta) {
              if (value == graphMin || value == graphMax) {
                return const SizedBox();
              }

              return SideTitleWidget(
                  axisSide: AxisSide.left,
                  child: Text(
                    value.toInt().toString().toCurrency(),
                    style: const TextStyle(fontSize: 10),
                  ));
            },
          ),
        ),
        //-------------------------// 左側の目盛り

        //-------------------------// 右側の目盛り
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 70,
            getTitlesWidget: (double value, TitleMeta meta) {
              if (value == graphMin || value == graphMax) {
                return const SizedBox();
              }

              return SideTitleWidget(
                  axisSide: AxisSide.left,
                  child: Text(
                    value.toInt().toString().toCurrency(),
                    style: const TextStyle(fontSize: 10),
                  ));
            },
          ),
        ),
        //-------------------------// 右側の目盛り
      ),

      ///
      lineBarsData: <LineChartBarData>[],
    );
  }
}
