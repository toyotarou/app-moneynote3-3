import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../collections/spend_time_place.dart';
import '../../extensions/extensions.dart';

class DispData {
  DispData(this.startDate, this.startPrice, this.lastDate, this.lastPrice);

  String startDate;
  int startPrice;

  String lastDate;
  int lastPrice;
}

/////////////////////////////////////////////

class MoneyScoreListAlert extends StatefulWidget {
  const MoneyScoreListAlert({
    super.key,
    required this.isar,
    required this.monthFirstDateList,
    required this.dateCurrencySumMap,
    required this.bankPriceTotalPadMap,
    required this.allSpendTimePlaceList,
  });

  final Isar isar;

  final List<String> monthFirstDateList;

  final Map<String, int> dateCurrencySumMap;

  final Map<String, int> bankPriceTotalPadMap;

  final List<SpendTimePlace> allSpendTimePlaceList;

  @override
  State<MoneyScoreListAlert> createState() => _MoneyScoreListAlertState();
}

class _MoneyScoreListAlertState extends State<MoneyScoreListAlert> {
  List<DispData> dispDataList = <DispData>[];

  Map<String, Map<String, int>> monthlySpendTimePlaceMap = <String, Map<String, int>>{};

  ///
  @override
  Widget build(BuildContext context) {
    makeMonthlySpendTimePlaceList();

    makeDispData();

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[const Text('収支一覧'), Container()],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(child: _displayDataList()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void makeMonthlySpendTimePlaceList() {
    monthlySpendTimePlaceMap = <String, Map<String, int>>{};

    final Map<String, Map<String, List<int>>> map = <String, Map<String, List<int>>>{};

    final List<String> yearmonth = <String>[];
    for (final SpendTimePlace element in widget.allSpendTimePlaceList) {
      yearmonth.add('${element.date.split('-')[0]}-${element.date.split('-')[1]}');
    }

    for (final String element in yearmonth) {
      map[element] = <String, List<int>>{'minus': <int>[], 'plus': <int>[]};
    }

    for (final SpendTimePlace element in widget.allSpendTimePlaceList) {
      final String ym = '${element.date.split('-')[0]}-${element.date.split('-')[1]}';

      if (element.price > 0) {
        map[ym]?['minus']?.add(element.price);
      } else {
        map[ym]?['plus']?.add(element.price);
      }
    }

    map.forEach((String key, Map<String, List<int>> value) {
      int minusSum = 0;
      int plusSum = 0;
      value['minus']?.forEach((int element) => minusSum += element);
      value['plus']?.forEach((int element) => plusSum += element);

      monthlySpendTimePlaceMap[key] = <String, int>{'minus': minusSum, 'plus': plusSum};
    });
  }

  ///
  void makeDispData() {
    dispDataList = <DispData>[];

    final String thisMonthYearMonth = DateTime(DateTime.now().year, DateTime.now().month).yyyymm;

    for (final String element in widget.monthFirstDateList) {
      final List<String> exDate = element.split('-');

      final String zenjitsu = DateTime(exDate[0].toInt(), exDate[1].toInt(), exDate[2].toInt() - 1).yyyymmdd;

      final int currencySum = widget.dateCurrencySumMap[zenjitsu] ?? 0;
      final int bankPriceTotal = widget.bankPriceTotalPadMap[zenjitsu] ?? 0;

      final int startPrice = currencySum + bankPriceTotal;

      int currency = 0;
      int bank = 0;

      String lastDate = '';
      int lastPrice = 0;

      if ('${exDate[0]}-${exDate[1]}' == thisMonthYearMonth) {
        widget.dateCurrencySumMap.forEach((String key, int value) {
          lastDate = key;
          currency = value;
        });
        widget.bankPriceTotalPadMap.forEach((String key, int value) => bank = value);
      } else {
        lastDate = DateTime(exDate[0].toInt(), exDate[1].toInt() + 1, 0).yyyymmdd;
        currency = widget.dateCurrencySumMap[lastDate] ?? 0;
        bank = widget.bankPriceTotalPadMap[lastDate] ?? 0;
      }

      lastPrice = currency + bank;

      dispDataList.add(DispData(element, startPrice, lastDate, lastPrice));
    }
  }

  ///
  Widget _displayDataList() {
    final List<Widget> list = <Widget>[];

    for (final DispData element in dispDataList) {
      final int mark = (element.startPrice < element.lastPrice) ? 1 : 0;

      final String ym = '${element.startDate.split('-')[0]}-${element.startDate.split('-')[1]}';

      list.add(Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(0.2))),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[Text(element.startDate), Text(element.startPrice.toString().toCurrency())],
                      ),
                      Container(),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.arrow_forward, color: Colors.white.withOpacity(0.4)),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[Text(element.lastDate), Text(element.lastPrice.toString().toCurrency())],
                  ),
                ),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10), child: dispUpDownIcon(mark: mark)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(),
                Row(
                  children: <Widget>[
                    Container(
                      width: 70,
                      alignment: Alignment.topRight,
                      child: Text(
                        (monthlySpendTimePlaceMap[ym]?['minus'] ?? 0).toString().toCurrency(),
                        style: const TextStyle(color: Colors.yellowAccent, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('+'),
                    const SizedBox(width: 10),
                    Container(
                      width: 70,
                      alignment: Alignment.topRight,
                      child: Text(
                        (monthlySpendTimePlaceMap[ym]?['plus'] ?? 0).toString().toCurrency(),
                        style: const TextStyle(color: Colors.greenAccent),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('='),
                    const SizedBox(width: 10),
                    Container(
                      width: 70,
                      alignment: Alignment.topRight,
                      child: Text(
                        ((monthlySpendTimePlaceMap[ym]?['minus'] ?? 0) + (monthlySpendTimePlaceMap[ym]?['plus'] ?? 0))
                            .toString()
                            .toCurrency(),
                        style: const TextStyle(color: Colors.orangeAccent),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ));
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) => list[index], childCount: list.length),
        ),
      ],
    );
  }

  ///
  Widget dispUpDownIcon({required int mark}) {
    switch (mark) {
      case 1:
        return const Icon(Icons.arrow_upward, color: Colors.greenAccent);
      case 0:
        return const Icon(Icons.arrow_downward, color: Colors.redAccent);
      default:
        return const Icon(Icons.crop_square, color: Colors.black);
    }
  }
}
