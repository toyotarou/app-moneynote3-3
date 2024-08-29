import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../collections/spend_item.dart';
import '../../collections/spend_time_place.dart';
import '../../extensions/extensions.dart';
import 'page/each_month_item_summary_page.dart';

class TabInfo {
  TabInfo(this.label, this.widget);

  String label;
  Widget widget;
}

class EachMonthItemSummaryAlert extends ConsumerStatefulWidget {
  const EachMonthItemSummaryAlert(
      {super.key,
      required this.spendTimePlaceList,
      required this.spendItemList});

  final List<SpendTimePlace> spendTimePlaceList;
  final List<SpendItem> spendItemList;

  @override
  ConsumerState<EachMonthItemSummaryAlert> createState() =>
      _EachMonthItemSummaryAlertState();
}

class _EachMonthItemSummaryAlertState
    extends ConsumerState<EachMonthItemSummaryAlert> {
  final List<TabInfo> _tabs = [];

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
        body: TabBarView(
          children: _tabs.map((tab) => tab.widget).toList(),
        ),
      ),
    );
  }

  ///
  void _makeTab() {
    final years = <int>[];

    for (var element in widget.spendTimePlaceList) {
      final exDate = element.date.split('-');

      if (!years.contains(exDate[0].toInt())) {
        years.add(exDate[0].toInt());
      }
    }

    for (var element in years) {
      _tabs.add(TabInfo(
        element.toString(),
        EachMonthItemSummaryPage(
          year: element,
          spendTimePlaceList: widget.spendTimePlaceList,
          spendItemList: widget.spendItemList,
        ),
      ));
    }
  }
}
