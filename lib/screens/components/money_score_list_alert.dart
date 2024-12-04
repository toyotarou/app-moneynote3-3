import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../collections/spend_time_place.dart';
import '../../extensions/extensions.dart';
import 'page/money_score_list_page.dart';

class TabInfo {
  TabInfo(this.label, this.widget);

  String label;
  Widget widget;
}

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
  List<TabInfo> _tabs = <TabInfo>[];

  ///
  @override
  Widget build(BuildContext context) {
    _makeTab();

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
        body: Column(
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
    );
  }

  ///
  void _makeTab() {
    _tabs = <TabInfo>[];

    final List<int> list = <int>[];

    for (int i = 2024; i <= DateTime.now().year; i++) {
      list.add(i);
    }

    list
      ..sort((int a, int b) => -1 * a.compareTo(b))
      ..forEach((int element) {
        _tabs.add(
          TabInfo(
            element.toString(),
            MoneyScoreListPage(
              isar: widget.isar,
              monthFirstDateList: widget.monthFirstDateList,
              dateCurrencySumMap: widget.dateCurrencySumMap,
              bankPriceTotalPadMap: widget.bankPriceTotalPadMap,
              allSpendTimePlaceList: widget.allSpendTimePlaceList,
              date: DateTime(element),
            ),
          ),
        );
      });
  }
}
