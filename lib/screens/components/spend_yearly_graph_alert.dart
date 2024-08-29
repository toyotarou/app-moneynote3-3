import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../collections/spend_item.dart';
import '../../extensions/extensions.dart';

class SpendYearlyGraphAlert extends StatefulWidget {
  const SpendYearlyGraphAlert({
    super.key,
    required this.spendTotal,
    required this.spendTotalMap,
    required this.amari,
    required this.spendItemList,
  });

  final int spendTotal;
  final Map<String, int> spendTotalMap;
  final int amari;
  final List<SpendItem> spendItemList;

  ///
  @override
  State<SpendYearlyGraphAlert> createState() => _SpendYearlyGraphAlertState();
}

class _SpendYearlyGraphAlertState extends State<SpendYearlyGraphAlert> {
  List<PieChartSectionData> graphDataList = [];

  ///
  @override
  void initState() {
    super.initState();

    makeGraphDataList();
  }

  ///
  void makeGraphDataList() {
    final spendItemColorMap = <String, String>{};

    for (var element in widget.spendItemList) {
      spendItemColorMap[element.spendItemName] = element.color;
    }

    widget.spendTotalMap.forEach((key, value) {
      final val = value / widget.spendTotal;

      final percent = val * 100;

      graphDataList.add(
        PieChartSectionData(
          borderSide: const BorderSide(color: Colors.white),
          color: (spendItemColorMap[key] != null) ? Color(spendItemColorMap[key]!.toInt()).withOpacity(0.2) : Colors.grey.withOpacity(0.2),
          value: val,
          title: '$key\n${value.toString().toCurrency()}\n${percent.toString().split('.')[0]} %',
          radius: 140,
          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    });

    final val2 = widget.amari / widget.spendTotal;

    final percent2 = val2 * 100;

    graphDataList.add(
      PieChartSectionData(
        borderSide: const BorderSide(color: Colors.white),
        color: Colors.grey.withOpacity(0.2),
        value: val2,
        title: 'その他\n${widget.amari.toString().toCurrency()}\n${percent2.toString().split('.')[0]} %',
        radius: 140,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  ///
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: DefaultTextStyle(
          style: GoogleFonts.kiwiMaru(fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('年間消費金額比率'), Container()],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('Spend Total'), Text(widget.spendTotal.toString().toCurrency())],
              ),
              const SizedBox(height: 10),
              _displayCircularGraph(),
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
        child: PieChart(PieChartData(startDegreeOffset: 270, sections: graphDataList, sectionsSpace: 2, centerSpaceRadius: 0)));
  }
}
