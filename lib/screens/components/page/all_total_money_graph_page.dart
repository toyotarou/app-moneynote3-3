import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:money_note/extensions/extensions.dart';
import 'package:money_note/utilities/utilities.dart';

class AllTotalMoneyGraphPage extends ConsumerStatefulWidget {
  const AllTotalMoneyGraphPage({super.key, this.data, required this.year});

  final List<Map<String, int>>? data;
  final int year;

  @override
  ConsumerState<AllTotalMoneyGraphPage> createState() =>
      _AllTotalMoneyGraphPageState();
}

class _AllTotalMoneyGraphPageState
    extends ConsumerState<AllTotalMoneyGraphPage> {
  final Utility _utility = Utility();

  LineChartData graphData = LineChartData();
  LineChartData graphData2 = LineChartData();

  List<FlSpot> _flspots = [];

  ///
  @override
  Widget build(BuildContext context) {
    _setChartData();

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: context.screenSize.width),
              Expanded(
                child: LineChart(graphData2),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: context.screenSize.width),
              Expanded(
                child: LineChart(graphData),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  void _setChartData() {
    _flspots = [];

    if (widget.data != null) {
      var i = 0;
      final list = <int>[];
      widget.data!.forEach((element) {
        element.entries.forEach((element2) {
          _flspots.add(FlSpot((i + 1).toDouble(), element2.value.toDouble()));

          list.add(element2.value);

          i++;
        });
      });

      const warisuu = 500000;
      final minValue = list.reduce(min);
      final maxValue = list.reduce(max);

      final graphMin = ((minValue / warisuu).floor()) * warisuu;
      final graphMax = ((maxValue / warisuu).ceil()) * warisuu;

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
              tooltipBgColor: Colors.white.withOpacity(0.2),
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                final list = <LineTooltipItem>[];

                touchedSpots.forEach((element) {
                  final textStyle = TextStyle(
                    color: element.bar.gradient?.colors.first ??
                        element.bar.color ??
                        Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  );

                  final price =
                      element.y.round().toString().split('.')[0].toCurrency();

                  final day = DateTime(widget.year)
                      .add(Duration(days: element.x.toInt() - 1))
                      .yyyymmdd;

                  list.add(
                    LineTooltipItem(
                      '$day\n$price',
                      textStyle,
                      textAlign: TextAlign.end,
                    ),
                  );
                });

                return list;
              }),
        ),

        ///
        gridData: FlGridData(
          verticalInterval: 1,
          getDrawingVerticalLine: (value) {
            final day =
                DateTime(widget.year).add(Duration(days: value.toInt()));

            return FlLine(
              color: (day.day == 1)
                  ? Colors.yellowAccent.withOpacity(0.3)
                  : Colors.transparent,
              strokeWidth: 1,
            );
          },
        ),

        ///
        titlesData: const FlTitlesData(show: false),

        ///
        borderData: FlBorderData(show: false),

        ///
        lineBarsData: [
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
        gridData: _utility.getFlGridData(),

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
              getTitlesWidget: (value, meta) {
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
          rightTitles: const AxisTitles(),
          //-------------------------// 右側の目盛り
        ),

        ///
        lineBarsData: [],
      );
    }
  }
}
