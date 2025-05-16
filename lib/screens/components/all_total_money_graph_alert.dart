// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../collections/spend_time_place.dart';
import '../../extensions/extensions.dart';
import 'page/all_total_money_graph_page.dart';

class TabInfo {
  TabInfo(this.label, this.widget);

  String label;
  Widget widget;
}

class AllTotalMoneyGraphAlert extends StatefulWidget {
  const AllTotalMoneyGraphAlert(
      {super.key,
      required this.allTotalMoneyMap,
      required this.years,
      required this.isar,
      required this.monthlyDateSumMap,
      required this.bankPriceTotalPadMap,
      required this.monthlySpendMap,
      required this.thisMonthSpendTimePlaceList,
      required this.allSpendTimePlaceList});

  final Map<String, int> allTotalMoneyMap;
  final List<int> years;
  final Isar isar;
  final Map<String, int> monthlyDateSumMap;
  final Map<String, int> bankPriceTotalPadMap;
  final Map<String, int> monthlySpendMap;
  final List<SpendTimePlace> thisMonthSpendTimePlaceList;
  final List<SpendTimePlace> allSpendTimePlaceList;

  ///
  @override
  State<AllTotalMoneyGraphAlert> createState() => _AllTotalMoneyGraphAlertState();
}

class _AllTotalMoneyGraphAlertState extends State<AllTotalMoneyGraphAlert> {
  List<TabInfo> _tabs = <TabInfo>[];

  GlobalKey globalKey = GlobalKey();

  double alertWidth = 0;

  ///
  @override
  Widget build(BuildContext context) {
    _makeTab();

    WidgetsBinding.instance.addPostFrameCallback(
      (Duration timeStamp) {
        setState(() {
          alertWidth = globalKey.currentContext!.size!.width;
        });
      },
    );

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Colors.transparent,
            //-------------------------//これを消すと「←」が出てくる（消さない）
            leading: const Icon(
              Icons.check_box_outline_blank,
              color: Colors.transparent,
            ),
            //-------------------------//これを消すと「←」が出てくる（消さない）

            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.blueAccent,
              tabs: _tabs.map((TabInfo tab) => Tab(text: tab.label)).toList(),
            ),
          ),
        ),
        body: Container(
          key: globalKey,
          child: Column(
            children: <Widget>[
              Container(width: context.screenSize.width),
              Expanded(
                child: TabBarView(
                  children: _tabs.map((TabInfo tab) => tab.widget).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void _makeTab() {
    _tabs = <TabInfo>[];

    final Map<int, List<Map<String, int>>> map = <int, List<Map<String, int>>>{};

    final Map<int, List<int>> map2 = <int, List<int>>{};

    widget.allTotalMoneyMap
      ..forEach((String key, int value) {
        final List<String> exKey = key.split('-');
        map[exKey[0].toInt()] = <Map<String, int>>[];

        map2[exKey[0].toInt()] = <int>[];
      })
      ..forEach((String key, int value) {
        final List<String> exKey = key.split('-');
        map[exKey[0].toInt()]?.add(<String, int>{key: value});

        map2[exKey[0].toInt()]?.add(exKey[1].toInt());
      });

    final Map<int, List<int>> map3 = <int, List<int>>{};

    map2.forEach((int key, List<int> value) {
      final List<int> monthList = <int>[];

      for (final int element in value) {
        if (!monthList.contains(element)) {
          monthList.add(element);
        }
      }

      map3[key] = monthList;
    });

    widget.years
      ..sort((int a, int b) => -1 * a.compareTo(b))
      ..forEach((int element) {
        if (map[element]!.length > 1) {
          _tabs.add(TabInfo(
            element.toString(),
            AllTotalMoneyGraphPage(
              year: element,
//              data: map[element],
              dataMap: map,
              alertWidth: alertWidth,
              monthList: map3[element] ?? <int>[],
              isar: widget.isar,
              monthlyDateSumMap: widget.monthlyDateSumMap,
              bankPriceTotalPadMap: widget.bankPriceTotalPadMap,
              monthlySpendMap: widget.monthlySpendMap,
              thisMonthSpendTimePlaceList: widget.thisMonthSpendTimePlaceList,
              allSpendTimePlaceList: widget.allSpendTimePlaceList,
            ),
          ));
        }
      });
  }
}
