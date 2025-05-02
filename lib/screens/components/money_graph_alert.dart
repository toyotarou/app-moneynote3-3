import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import '../../collections/spend_time_place.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';

class MoneyGraphAlert extends ConsumerStatefulWidget {
  const MoneyGraphAlert({
    super.key,
    required this.date,
    required this.isar,
    required this.monthlyDateSumMap,
    required this.bankPriceTotalPadMap,
    required this.monthlySpendMap,
    required this.graphMin,
    required this.graphMax,
    required this.thisMonthSpendTimePlaceList,
    required this.monthSTPList,
  });

  final DateTime date;
  final Isar isar;

  final Map<String, int> monthlyDateSumMap;
  final Map<String, int> bankPriceTotalPadMap;

  final Map<String, int> monthlySpendMap;

  final int graphMin;
  final int graphMax;

  final List<SpendTimePlace> thisMonthSpendTimePlaceList;

  final List<SpendTimePlace> monthSTPList;

  @override
  ConsumerState<MoneyGraphAlert> createState() => _MoneyGraphAlertState();
}

class _MoneyGraphAlertState extends ConsumerState<MoneyGraphAlert> with ControllersMixin<MoneyGraphAlert> {
  LineChartData graphData = LineChartData();
  LineChartData graphData2 = LineChartData();

  List<FlSpot> _flspots = <FlSpot>[];

  Map<String, String> _dateMap = <String, String>{};

  ///
  @override
  Widget build(BuildContext context) {
    _setChartData();

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: context.screenSize.width),
              const SizedBox(height: 80),
              const Divider(color: Colors.transparent, thickness: 5),
              Expanded(child: LineChart(graphData2)),
              const SizedBox(height: 60),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(width: context.screenSize.width),
              SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.date.yyyymm,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => moneyGraphNotifier.setDisplayGraphFlag(flag: 'total'),
                          child: Text(
                            '所持金額',
                            style: TextStyle(
                                fontSize: 12,
                                color: (moneyGraphState.displayGraphFlag == 'total')
                                    ? Colors.yellowAccent
                                    : Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () => moneyGraphNotifier.setDisplayGraphFlag(flag: 'diff'),
                          child: Text(
                            '繰越比較',
                            style: TextStyle(
                                fontSize: 12,
                                color: (moneyGraphState.displayGraphFlag == 'diff')
                                    ? Colors.yellowAccent
                                    : Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () => moneyGraphNotifier.setDisplayGraphFlag(flag: 'spend'),
                          child: Text(
                            '使用金額',
                            style: TextStyle(
                                fontSize: 12,
                                color: (moneyGraphState.displayGraphFlag == 'spend')
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
              const SizedBox(height: 60),
            ],
          ),
        ],
      ),
    );
  }

  ///
  void _setChartData() {
    final Map<String, int> map = <String, int>{};

    int warisuu = 500000;

    switch (moneyGraphState.displayGraphFlag) {
      case 'total':
        widget.monthlyDateSumMap.forEach((String key, int value) {
          if (widget.date.yyyymm == DateTime.parse('$key 00:00:00').yyyymm) {
            final int value2 = widget.bankPriceTotalPadMap[key] ?? 0;
            map[key] = value + value2;
          }
        });

      case 'diff':
        final Map<String, List<int>> map100 = <String, List<int>>{};

        final int endDay = DateTime(widget.date.year, widget.date.month + 1, 0).day;

        for (int i = 1; i <= endDay; i++) {
          final String genDate = DateTime(widget.date.year, widget.date.month, i).yyyymmdd;
          map100[genDate] = <int>[0];
        }

        for (final SpendTimePlace element in widget.monthSTPList) {
          if (element.date.split('-')[0] == widget.date.yyyy) {
            map100[element.date] = <int>[];
          }
        }

        for (final SpendTimePlace element in widget.monthSTPList) {
          if (element.date.split('-')[0] == widget.date.yyyy) {
            map100[element.date]?.add(element.price);
          }
        }

        int total = 0;
        map100.forEach((String key, List<int> value) {
          for (final int element in value) {
            total += element * -1;
          }
          map[key] = total;
        });

        warisuu = 50000;

      case 'spend':
        final Map<String, List<int>> map100 = <String, List<int>>{};

        final int endDay = DateTime(widget.date.year, widget.date.month + 1, 0).day;

        for (int i = 1; i <= endDay; i++) {
          final String genDate = DateTime(widget.date.year, widget.date.month, i).yyyymmdd;
          map100[genDate] = <int>[0];
        }

        for (final SpendTimePlace element in widget.monthSTPList) {
          if (element.date.split('-')[0] == widget.date.yyyy) {
            map100[element.date] = <int>[];
          }
        }

        for (final SpendTimePlace element in widget.monthSTPList) {
          if (element.date.split('-')[0] == widget.date.yyyy) {
            map100[element.date]?.add(element.price);
          }
        }

        int total = 0;
        map100.forEach((String key, List<int> value) {
          int sum = 0;
          for (final int element in value) {
            sum += (element > 0) ? element : 0;
          }

          total += sum;
          map[key] = total;
        });

        warisuu = 50000;
    }

    _flspots = <FlSpot>[];
    _dateMap = <String, String>{};

    String lastDate = '';
    int lastTotal = 0;

    final List<int> list = <int>[];

    int i = 0;

    map.forEach((String key, int value) {
      _flspots.add(FlSpot((i + 1).toDouble(), value.toDouble()));
      _dateMap[(i + 1).toString()] = key;
      list.add(value);

      lastDate = key;
      if (value > 0) {
        lastTotal = value;
      }

      i++;
    });

    if (moneyGraphState.displayGraphFlag == 'total') {
      final List<String> exLastDate = lastDate.split('-');

      final int lastDateMonthLastDay = DateTime(exLastDate[0].toInt(), exLastDate[1].toInt() + 1, 0).day;

      for (int i = list.length; i <= (lastDateMonthLastDay - exLastDate[2].toInt()) + list.length; i++) {
        _flspots.add(FlSpot(i.toDouble(), lastTotal.toDouble()));
      }
    }

    if (list.isNotEmpty) {
      final int minValue = list.reduce(min);
      final int maxValue = list.reduce(max);

      final int graphMin =
          (moneyGraphState.displayGraphFlag == 'total') ? widget.graphMin : ((minValue / warisuu).floor()) * warisuu;
      final int graphMax =
          (moneyGraphState.displayGraphFlag == 'total') ? widget.graphMax : ((maxValue / warisuu).ceil()) * warisuu;

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
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                final List<LineTooltipItem> list = <LineTooltipItem>[];

                for (final LineBarSpot element in touchedSpots) {
                  final TextStyle textStyle = TextStyle(
                    color: element.bar.gradient?.colors.first ?? element.bar.color ?? Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  );

                  final String price = element.y.round().toString().split('.')[0].toCurrency();

                  final String day =
                      DateTime(widget.date.year, widget.date.month).add(Duration(days: element.x.toInt() - 1)).yyyymmdd;

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
        gridData: FlGridData(
          verticalInterval: 1,
          getDrawingHorizontalLine: (double value) {
            return FlLine(
                color: (value == 0.0) ? Colors.greenAccent.withOpacity(0.8) : Colors.white.withOpacity(0.2),
                strokeWidth: 1);
          },
          getDrawingVerticalLine: (double value) {
            final String youbi =
                DateTime(widget.date.year, widget.date.month).add(Duration(days: value.toInt() - 1)).youbiStr;

            if (widget.date.year != DateTime.now().year) {
              value = -1;
            }

            return FlLine(
              color: (value.toInt() == DateTime.now().day)
                  ? const Color(0xFFFBB6CE).withOpacity(0.3)
                  : (youbi == 'Sunday')
                      ? Colors.yellowAccent.withOpacity(0.3)
                      : Colors.transparent,
              strokeWidth: (value.toInt() == DateTime.now().day) ? 3 : 1,
            );
          },
        ),

        ///
        titlesData: const FlTitlesData(show: false),

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
                    meta: meta,
                    space: 4,
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
                    meta: meta,
                    space: 4,
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
}

///
////////////////////////////////////////////////////////////
final AutoDisposeStateNotifierProvider<GraphWidthStateNotifier, double> graphWidthProvider =
    StateNotifierProvider.autoDispose<GraphWidthStateNotifier, double>(
        (AutoDisposeStateNotifierProviderRef<GraphWidthStateNotifier, double> ref) => GraphWidthStateNotifier());

class GraphWidthStateNotifier extends StateNotifier<double> {
  GraphWidthStateNotifier() : super(0.6);

  ///
  Future<void> setGraphWidth({required double width}) async => state = width;
}
