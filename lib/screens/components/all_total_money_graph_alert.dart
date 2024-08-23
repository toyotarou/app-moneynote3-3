// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:money_note/extensions/extensions.dart';
import 'package:money_note/screens/components/page/all_total_money_graph_page.dart';

class TabInfo {
  TabInfo(this.label, this.widget);

  String label;
  Widget widget;
}

// ignore: must_be_immutable
class AllTotalMoneyGraphAlert extends HookWidget {
  AllTotalMoneyGraphAlert(
      {super.key, required this.allTotalMoneyMap, required this.years});

  final Map<String, int> allTotalMoneyMap;
  final List<int> years;

  List<TabInfo> _tabs = [];

  ///
  @override
  Widget build(BuildContext context) {
    _makeTab();

    final tabController = useTabController(initialLength: _tabs.length);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: const Icon(Icons.check_box_outline_blank,
            color: Colors.transparent),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        bottom: TabBar(
          controller: tabController,
          isScrollable: true,
          indicatorColor: Colors.blueAccent,
          tabs: _tabs.map((TabInfo tab) => Tab(text: tab.label)).toList(),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: _tabs.map((tab) => tab.widget).toList(),
      ),
    );
  }

  ///
  void _makeTab() {
    _tabs = [];

    final map = <int, List<Map<String, int>>>{};

    allTotalMoneyMap
      ..forEach((key, value) {
        final exKey = key.split('-');
        map[exKey[0].toInt()] = [];
      })
      ..forEach((key, value) {
        final exKey = key.split('-');
        map[exKey[0].toInt()]?.add({key: value});
      });

    years.forEach((element) {
      if (map[element]!.length > 1) {
        _tabs.add(TabInfo(
          element.toString(),
          AllTotalMoneyGraphPage(
            year: element,
            data: map[element],
          ),
        ));
      }
    });
  }
}
