import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:money_note/extensions/extensions.dart';
import 'package:money_note/utilities/utilities.dart';

class AllTotalMoneyGraphPage extends ConsumerStatefulWidget {
  const AllTotalMoneyGraphPage({super.key, this.data});

  final List<Map<String, int>>? data;

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

      var warisuu = 500000;
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
            tooltipBgColor: Colors.white.withOpacity(0.3),
            getTooltipItems: _utility.getGraphToolTip,
          ),
        ),

        ///
        gridData: _utility.getFlGridData(),

        ///
        titlesData: const FlTitlesData(
          //-------------------------// 上部の目盛り
          topTitles: AxisTitles(),
          //-------------------------// 上部の目盛り

          //-------------------------// 下部の目盛り
          bottomTitles: AxisTitles(),
          //-------------------------// 下部の目盛り

          //-------------------------// 左側の目盛り
          leftTitles: AxisTitles(),
          //-------------------------// 左側の目盛り

          //-------------------------// 右側の目盛り
          rightTitles: AxisTitles(),
          //-------------------------// 右側の目盛り
        ),

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
