import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../extensions/extensions.dart';
import '../../state/money_graph/money_graph_notifier.dart';
import '../../utilities/utilities.dart';

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
  final Utility _utility = Utility();

  LineChartData _data = LineChartData();

  List<FlSpot> _flspots = [];

  Map<String, String> _dateMap = {};

  final double _minGraphRate = 0.6;

  final ScrollController _scrollController = ScrollController();

  ///
  @override
  Widget build(BuildContext context) {
    _setChartData();

    final graphWidthState = ref.watch(graphWidthProvider);

    final displayGraphFlag = ref.watch(moneyGraphProvider.select((value) => value.displayGraphFlag));

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: SizedBox(
          width: context.screenSize.width * graphWidthState,
          height: context.screenSize.height - 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: context.screenSize.width),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => ref.read(moneyGraphProvider.notifier).setDisplayGraphFlag(flag: 'total'),
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
                        onTap: () => ref.read(moneyGraphProvider.notifier).setDisplayGraphFlag(flag: 'spend'),
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
                  Container(),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              const SizedBox(height: 20),
              Expanded(child: LineChart(_data)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo.withOpacity(0.3),
                        ),
                        onPressed: () => ref.read(graphWidthProvider.notifier).setGraphWidth(
                              width: (graphWidthState == _minGraphRate)
                                  ? (_flspots.length / 10).ceil().toDouble()
                                  : _minGraphRate,
                            ),
                        child: const Text('width'),
                      ),
                      if (graphWidthState > _minGraphRate)
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.3)),
                              onPressed: () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
                              child: const Text('jump'),
                            ),
                          ],
                        ),
                    ],
                  ),
                  if (graphWidthState > _minGraphRate)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.3)),
                      onPressed: () => _scrollController.jumpTo(_scrollController.position.minScrollExtent),
                      child: const Text('back'),
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
    final map = <String, int>{};

    final displayGraphFlag = ref.watch(moneyGraphProvider.select((value) => value.displayGraphFlag));

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

    final minValue = list.reduce(min);
    final maxValue = list.reduce(max);

    final graphMin = ((minValue / warisuu).floor()) * warisuu;
    final graphMax = ((maxValue / warisuu).ceil()) * warisuu;

    _data = LineChartData(
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
      titlesData: FlTitlesData(
        //-------------------------// 上部の目盛り
        topTitles: const AxisTitles(),
        //-------------------------// 上部の目盛り

        //-------------------------// 下部の目盛り
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            getTitlesWidget: (value, meta) {
              final year =
                  DateTime.parse(_dateMap[value.toInt().toString()].toString()).year.toString().padLeft(2, '0');
              final month =
                  DateTime.parse(_dateMap[value.toInt().toString()].toString()).month.toString().padLeft(2, '0');
              final day = DateTime.parse(_dateMap[value.toInt().toString()].toString()).day.toString().padLeft(2, '0');
              final monthday = '$month-$day';

              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: DefaultTextStyle(
                  style: const TextStyle(fontSize: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(year), Text(monthday)],
                  ),
                ),
              );
            },
          ),
        ),
        //-------------------------// 下部の目盛り

        //-------------------------// 左側の目盛り
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: _showSideTitles(flag: 'left'),
            reservedSize: _getLeftTitleWidth(),
            getTitlesWidget: (value, meta) => Text(value.toInt().toString().toCurrency()),
          ),
        ),
        //-------------------------// 左側の目盛り

        //-------------------------// 右側の目盛り
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: _showSideTitles(flag: 'right'),
            reservedSize: 100,
            getTitlesWidget: (value, meta) => Text(value.toInt().toString().toCurrency()),
          ),
        ),
        //-------------------------// 右側の目盛り
      ),

      ///
      lineBarsData: [
        LineChartBarData(spots: _flspots, barWidth: 5, isStrokeCapRound: true, color: Colors.yellowAccent),
      ],
    );
  }

  ///
  bool _showSideTitles({required String flag}) {
    final graphWidthState = ref.watch(graphWidthProvider);

    // ignore: avoid_bool_literals_in_conditional_expressions
    var showTitles = (graphWidthState == _minGraphRate) ? false : true;

    if (flag == 'left') {
      if (_dateMap.length <= 5) {
        showTitles = true;
      }
    }

    return showTitles;
  }

  ///
  double _getLeftTitleWidth() {
    var width = 100.0;

    switch (_dateMap.length) {
      case 1:
      case 2:
        width = context.screenSize.width / 2;
        break;

      case 3:
        width = context.screenSize.width / 3;
        break;

      default:
        width = 100;
        break;
    }

    return width;
  }
}

///
////////////////////////////////////////////////////////////
final graphWidthProvider =
    StateNotifierProvider.autoDispose<GraphWidthStateNotifier, double>((ref) => GraphWidthStateNotifier());

class GraphWidthStateNotifier extends StateNotifier<double> {
  GraphWidthStateNotifier() : super(0.6);

  ///
  Future<void> setGraphWidth({required double width}) async => state = width;
}
