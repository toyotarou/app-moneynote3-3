import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../collections/spend_item.dart';
import '../../extensions/extensions.dart';
import '../../state/app_params/app_params_notifier.dart';
import '../../state/app_params/app_params_response_state.dart';

class SpendYearlyGraphAlert extends ConsumerStatefulWidget {
  const SpendYearlyGraphAlert({
    super.key,
    required this.spendTotal,
    required this.spendTotalMap,
    required this.amari,
    required this.spendItemList,
    required this.eachItemSpendMap,
  });

  final int spendTotal;
  final Map<String, int> spendTotalMap;
  final int amari;
  final List<SpendItem> spendItemList;
  final Map<String, int> eachItemSpendMap;

  ///
  @override
  ConsumerState<SpendYearlyGraphAlert> createState() => _SpendYearlyGraphAlertState();
}

class _SpendYearlyGraphAlertState extends ConsumerState<SpendYearlyGraphAlert> {
  List<PieChartSectionData> graphDataList = <PieChartSectionData>[];

  ///
  void makeGraphDataList() {
    graphDataList = <PieChartSectionData>[];

    final Map<String, String> spendItemColorMap = <String, String>{};

    for (final SpendItem element in widget.spendItemList) {
      spendItemColorMap[element.spendItemName] = element.color;
    }

    final String selectedYearlySpendCircleGraphSpendItem = ref.watch(
        appParamProvider.select((AppParamsResponseState value) => value.selectedYearlySpendCircleGraphSpendItem));

    final Map<int, List<String>> spendTotalGuideMap = <int, List<String>>{};

    final List<int> guideIntList = <int>[];

    widget.spendTotalMap.forEach((String key, int value) {
      spendTotalGuideMap[value] = <String>[];

      guideIntList.add(value);
    });

    widget.spendTotalMap.forEach((String key, int value) => spendTotalGuideMap[value]?.add(key));

    guideIntList
      ..sort((int a, int b) => a.compareTo(b) * -1)
      ..forEach((int element) {
        spendTotalGuideMap[element]?.forEach((String element2) {
          final double val = element / widget.spendTotal;

          final double percent = val * 100;

          graphDataList.add(
            PieChartSectionData(
              borderSide: const BorderSide(color: Colors.white),
              color: (spendItemColorMap[element2] != null)
                  ? Color(spendItemColorMap[element2]!.toInt()).withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              value: val,
              title: (selectedYearlySpendCircleGraphSpendItem == '')
                  ? '$element2\n${element.toString().toCurrency()}\n${percent.toStringAsFixed(2)} %'
                  : (element2 == selectedYearlySpendCircleGraphSpendItem)
                      ? '$element2\n${element.toString().toCurrency()}\n${percent.toStringAsFixed(2)} %'
                      : '',
              radius: 140,
              titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          );
        });
      });

    final double val2 = widget.amari / widget.spendTotal;

    final double percent2 = val2 * 100;

    graphDataList.add(
      PieChartSectionData(
        borderSide: const BorderSide(color: Colors.white),
        color: Colors.grey.withOpacity(0.2),
        value: val2,
        title: (selectedYearlySpendCircleGraphSpendItem == '')
            ? 'その他\n${widget.amari.toString().toCurrency()}\n${percent2.toStringAsFixed(2)} %'
            : '',
        radius: 140,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    makeGraphDataList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DefaultTextStyle(
          style: GoogleFonts.kiwiMaru(fontSize: 12),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[const Text('年間消費金額比率'), Container()],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[const Text('Spend Total'), Text(widget.spendTotal.toString().toCurrency())],
              ),
              const SizedBox(height: 10),
              _displayCircularGraph(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(),
                    GestureDetector(
                      onTap: () =>
                          ref.read(appParamProvider.notifier).setSelectedYearlySpendCircleGraphSpendItem(item: ''),
                      child:
                          Text('clear', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                    ),
                  ],
                ),
              ),
              Expanded(child: displayEachItemSpendMap()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayCircularGraph() {
    return Container(
        height: 300,
        padding: const EdgeInsets.all(10),
        child: PieChart(
            PieChartData(startDegreeOffset: 270, sections: graphDataList, sectionsSpace: 2, centerSpaceRadius: 0)));
  }

  ///
  Widget displayEachItemSpendMap() {
    final Map<String, String> spendItemColorMap = <String, String>{};

    for (final SpendItem element in widget.spendItemList) {
      spendItemColorMap[element.spendItemName] = element.color;
    }

    final List<Widget> list = <Widget>[];

    final Map<int, List<String>> spendTotalGuideMap = <int, List<String>>{};

    final List<int> guideIntList = <int>[];

    widget.eachItemSpendMap.forEach((String key, int value) {
      spendTotalGuideMap[value] = <String>[];

      guideIntList.add(value);
    });

    widget.eachItemSpendMap.forEach((String key, int value) => spendTotalGuideMap[value]?.add(key));

    guideIntList
      ..sort((int a, int b) => a.compareTo(b) * -1)
      ..forEach((int element) {
        if (element > 0) {
          final String percent = (element / widget.spendTotal * 100).toStringAsFixed(2);

          spendTotalGuideMap[element]?.forEach((String element2) {
            final Color lineColor =
                (spendItemColorMap[element2] != null) ? Color(spendItemColorMap[element2]!.toInt()) : Colors.grey;

            list.add(Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
              child: DefaultTextStyle(
                style: const TextStyle(fontSize: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 40,
                          alignment: Alignment.topLeft,
                          child: ((element / 100000).floor() > 1)
                              ? GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(appParamProvider.notifier)
                                        .setSelectedYearlySpendCircleGraphSpendItem(item: element2);
                                  },
                                  child: CircleAvatar(radius: 10, backgroundColor: lineColor.withOpacity(0.4)),
                                )
                              : Container(),
                        ),
                        Text(element2),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(element.toString().toCurrency()),
                        Container(width: 70, alignment: Alignment.topRight, child: Text('$percent %')),
                      ],
                    ),
                  ],
                ),
              ),
            ));
          });
        }
      });

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) => list[index], childCount: list.length),
        ),
      ],
    );
  }
}
