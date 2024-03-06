import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/money.dart';
import '../../extensions/extensions.dart';
import 'page/daily_money_display_page.dart';

class TabInfo {
  TabInfo(this.label, this.widget);

  String label;
  Widget widget;
}

class DailyMoneyDisplayAlert extends ConsumerStatefulWidget {
  const DailyMoneyDisplayAlert({super.key, required this.date, required this.isar, required this.moneyMap});

  final DateTime date;
  final Isar isar;

  final Map<String, Money> moneyMap;

  @override
  ConsumerState<DailyMoneyDisplayAlert> createState() => _DailyMoneyDisplayAlertState();
}

class _DailyMoneyDisplayAlertState extends ConsumerState<DailyMoneyDisplayAlert> {
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
            leading: const Icon(Icons.check_box_outline_blank, color: Colors.transparent),
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
    _tabs = [
      TabInfo(
        '${widget.date.yyyymmdd} (${widget.date.youbiStr.substring(0, 3)})',
        DailyMoneyDisplayPage(date: widget.date, isar: widget.isar),
      ),
    ];

    for (var i = 1; i < 7; i++) {
      final day = widget.date.add(Duration(days: i * -1));

      final youbi = day.youbiStr.substring(0, 3);

      if (widget.moneyMap[day.yyyymmdd] != null) {
        _tabs.add(
          TabInfo(
            '${day.yyyymmdd} ($youbi)',
            DailyMoneyDisplayPage(date: day, isar: widget.isar),
          ),
        );
      }
    }
  }
}
