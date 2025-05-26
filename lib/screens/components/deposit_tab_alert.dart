import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import 'bank_name_list_alert.dart';
import 'emoney_name_list_alert.dart';

class TabInfo {
  TabInfo(this.label, this.widget);

  String label;
  Widget widget;
}

// ignore: must_be_immutable
class DepositTabAlert extends HookConsumerWidget {
  DepositTabAlert({super.key, this.index, required this.isar, required this.buttonLabelTextList});

  int? index;
  final Isar isar;
  final List<String> buttonLabelTextList;

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<TabInfo> tabs = <TabInfo>[];

    if (buttonLabelTextList.contains('金融機関')) {
      tabs.add(TabInfo('金融機関管理', BankNameListAlert(isar: isar)));
    }

    if (buttonLabelTextList.contains('電子マネー')) {
      tabs.add(TabInfo('電子マネー管理', EmoneyNameListAlert(isar: isar)));
    }

    // 最初に開くタブを指定する
    final TabController tabController = useTabController(initialLength: tabs.length);
    if (index != null) {
      tabController.index = index!;
    }
    // 最初に開くタブを指定する

    return DefaultTabController(
      length: tabs.length,
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
              //================================//
              controller: tabController,
              //================================//

              isScrollable: true,
              indicatorColor: Colors.blueAccent,
              tabs: tabs.map((TabInfo tab) => Tab(text: tab.label)).toList(),
            ),
          ),
        ),
        body: TabBarView(
          //================================//
          controller: tabController,
          //================================//

          children: tabs.map((TabInfo tab) => tab.widget).toList(),
        ),
      ),
    );
  }
}
