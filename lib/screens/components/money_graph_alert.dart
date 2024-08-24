import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:money_note/extensions/extensions.dart';
import 'package:money_note/state/money_graph/money_graph_notifier.dart';

class MoneyGraphAlert extends ConsumerStatefulWidget {
  const MoneyGraphAlert({
    super.key,
    required this.date,
    required this.isar,
    required this.monthlyDateSumMap,
    required this.bankPriceTotalPadMap,
    required this.monthlySpendMap,
  });

  final DateTime date;
  final Isar isar;

  final Map<String, int> monthlyDateSumMap;
  final Map<String, int> bankPriceTotalPadMap;

  final Map<String, int> monthlySpendMap;

  @override
  ConsumerState<MoneyGraphAlert> createState() => _MoneyGraphAlertState();
}

class _MoneyGraphAlertState extends ConsumerState<MoneyGraphAlert> {
  LineChartData graphData = LineChartData();
  LineChartData graphData2 = LineChartData();

  List<FlSpot> _flspots = [];

  Map<String, String> _dateMap = {};

  ///
  @override
  Widget build(BuildContext context) {
    _setChartData();

    final displayGraphFlag =
        ref.watch(moneyGraphProvider.select((value) => value.displayGraphFlag));

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: context.screenSize.width),
              const SizedBox(height: 50),
              const Divider(color: Colors.transparent, thickness: 5),
              Expanded(child: LineChart(graphData2)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: context.screenSize.width),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.date.yyyymm,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => ref
                              .read(moneyGraphProvider.notifier)
                              .setDisplayGraphFlag(flag: 'total'),
                          child: Text(
                            '所持金額',
                            style: TextStyle(
                                fontSize: 12,
                                color: (displayGraphFlag == 'total')
                                    ? Colors.yellowAccent
                                    : Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () => ref
                              .read(moneyGraphProvider.notifier)
                              .setDisplayGraphFlag(flag: 'spend'),
                          child: Text(
                            '使用金額',
                            style: TextStyle(
                                fontSize: 12,
                                color: (displayGraphFlag == 'spend')
                                    ? Colors.yellowAccent
                                    : Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(child: LineChart(graphData)),
            ],
          ),
        ],
      ),
    );
  }

  ///
  void _setChartData() {
    final map = <String, int>{};

    final displayGraphFlag =
        ref.watch(moneyGraphProvider.select((value) => value.displayGraphFlag));

    var warisuu = 500000;

    switch (displayGraphFlag) {
      case 'total':
        widget.monthlyDateSumMap.forEach((key, value) {
          if (widget.date.yyyymm == DateTime.parse('$key 00:00:00').yyyymm) {
            final value2 = widget.bankPriceTotalPadMap[key] ?? 0;
            map[key] = value + value2;
          }
        });
        break;

      case 'spend':
        widget.monthlySpendMap.forEach((key, value) {
          if (widget.date.yyyymm == DateTime.parse('$key 00:00:00').yyyymm) {
            map[key] = value;
          }
        });

        warisuu = 50000;

        break;
    }

    _flspots = [];
    _dateMap = {};

    final list = <int>[];

    var i = 0;

    map.forEach((key, value) {
      _flspots.add(FlSpot((i + 1).toDouble(), value.toDouble()));
      _dateMap[(i + 1).toString()] = key;
      list.add(value);
      i++;
    });

    if (list.isNotEmpty) {
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
        borderData: FlBorderData(show: false),

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

                  final day = DateTime(widget.date.year, widget.date.month)
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
          getDrawingHorizontalLine: (value) {
            return FlLine(
                color: (value == 0.0)
                    ? Colors.greenAccent.withOpacity(0.8)
                    : Colors.white.withOpacity(0.2),
                strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: Colors.white.withOpacity(0.2), strokeWidth: 1);
          },
        ),

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

///
////////////////////////////////////////////////////////////
final graphWidthProvider =
    StateNotifierProvider.autoDispose<GraphWidthStateNotifier, double>(
        (ref) => GraphWidthStateNotifier());

class GraphWidthStateNotifier extends StateNotifier<double> {
  GraphWidthStateNotifier() : super(0.6);

  ///
  Future<void> setGraphWidth({required double width}) async => state = width;
}
