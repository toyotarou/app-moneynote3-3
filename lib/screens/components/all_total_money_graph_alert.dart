import 'package:flutter/material.dart';
import 'package:money_note/extensions/extensions.dart';
import 'package:money_note/screens/components/page/all_total_money_graph_page.dart';

class TabInfo {
  TabInfo(this.label, this.widget);

  String label;
  Widget widget;
}

class AllTotalMoneyGraphAlert extends StatefulWidget {
  const AllTotalMoneyGraphAlert(
      {super.key, required this.allTotalMoneyMap, required this.years});

  final Map<String, int> allTotalMoneyMap;
  final List<int> years;

  @override
  State<AllTotalMoneyGraphAlert> createState() =>
      _AllTotalMoneyGraphAlertState();
}

class _AllTotalMoneyGraphAlertState extends State<AllTotalMoneyGraphAlert> {
  List<TabInfo> _tabs = [];

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
            leading: const Icon(Icons.check_box_outline_blank,
                color: Colors.transparent),
            //-------------------------//これを消すと「←」が出てくる（消さない）

            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.blueAccent,
              tabs: _tabs.map((TabInfo tab) => Tab(text: tab.label)).toList(),
            ),
          ),
        ),
        body: TabBarView(children: _tabs.map((tab) => tab.widget).toList()),
      ),
    );
  }

  ///
  void _makeTab() {
    _tabs = [];

    final map = <int, List<Map<String, int>>>{};

    widget.allTotalMoneyMap.forEach((key, value) {
      final exKey = key.split('-');
      map[exKey[0].toInt()] = [];
    });

    widget.allTotalMoneyMap.forEach((key, value) {
      final exKey = key.split('-');
      map[exKey[0].toInt()]?.add({key: value});
    });

    widget.years.forEach((element) {
      if (map[element]!.length > 1) {
        _tabs.add(TabInfo(
          element.toString(),
          AllTotalMoneyGraphPage(data: map[element]),
        ));
      }
    });
  }
}
