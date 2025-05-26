import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/bank_name.dart';
import '../../collections/emoney_name.dart';
import '../../collections/money.dart';
import '../../collections/spend_item.dart';
import '../../collections/spend_time_place.dart';
import '../../extensions/extensions.dart';
import '../../utilities/utilities.dart';
import 'page/daily_money_display_page.dart';

class TabInfo {
  TabInfo(this.label, this.widget);

  String label;
  Widget widget;
}

class DailyMoneyDisplayAlert extends ConsumerStatefulWidget {
  const DailyMoneyDisplayAlert({
    super.key,
    required this.date,
    required this.isar,
    required this.moneyMap,
    required this.bankPricePadMap,
    required this.bankPriceTotalPadMap,
    required this.bankNameList,
    required this.emoneyNameList,
    required this.spendItemList,
    required this.thisMonthSpendTimePlaceList,
    required this.prevMonthSpendTimePlaceList,
    required this.configMap,
  });

  final DateTime date;
  final Isar isar;

  final Map<String, Money> moneyMap;

  final Map<String, Map<String, int>> bankPricePadMap;
  final Map<String, int> bankPriceTotalPadMap;

  final List<SpendTimePlace> thisMonthSpendTimePlaceList;
  final List<SpendTimePlace> prevMonthSpendTimePlaceList;

  final List<BankName> bankNameList;
  final List<EmoneyName> emoneyNameList;

  final List<SpendItem> spendItemList;

  final Map<String, String> configMap;

  @override
  ConsumerState<DailyMoneyDisplayAlert> createState() => _DailyMoneyDisplayAlertState();
}

class _DailyMoneyDisplayAlertState extends ConsumerState<DailyMoneyDisplayAlert> {
  final Utility _utility = Utility();

  List<TabInfo> _tabs = <TabInfo>[];

  Map<String, List<SpendTimePlace>> monthlySpendTimePlaceMap = <String, List<SpendTimePlace>>{};

  ///
  @override
  void initState() {
    super.initState();

    for (final SpendTimePlace element in widget.prevMonthSpendTimePlaceList) {
      monthlySpendTimePlaceMap[element.date] = <SpendTimePlace>[];
    }

    for (final SpendTimePlace element in widget.prevMonthSpendTimePlaceList) {
      monthlySpendTimePlaceMap[element.date]?.add(element);
    }

    for (final SpendTimePlace element in widget.thisMonthSpendTimePlaceList) {
      monthlySpendTimePlaceMap[element.date] = <SpendTimePlace>[];
    }

    for (final SpendTimePlace element in widget.thisMonthSpendTimePlaceList) {
      monthlySpendTimePlaceMap[element.date]?.add(element);
    }
  }

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
        body: TabBarView(children: _tabs.map((TabInfo tab) => tab.widget).toList()),
      ),
    );
  }

  ///
  void _makeTab() {
    final DateTime beforeDate = DateTime(widget.date.year, widget.date.month, widget.date.day - 1);

    _tabs = <TabInfo>[
      TabInfo(
        '${widget.date.yyyymmdd} (${widget.date.youbiStr.substring(0, 3)})',
        DailyMoneyDisplayPage(
          date: widget.date,
          isar: widget.isar,
          moneyList: (widget.moneyMap[widget.date.yyyymmdd] != null)
              ? <Money>[widget.moneyMap[widget.date.yyyymmdd]!]
              : <Money>[],
          onedayMoneyTotal: (widget.moneyMap[widget.date.yyyymmdd] != null)
              ? _utility.makeCurrencySum(money: widget.moneyMap[widget.date.yyyymmdd])
              : 0,
          beforeMoneyList: (widget.moneyMap[beforeDate.yyyymmdd] != null)
              ? <Money>[widget.moneyMap[beforeDate.yyyymmdd]!]
              : <Money>[],
          beforeMoneyTotal: (widget.moneyMap[beforeDate.yyyymmdd] != null)
              ? _utility.makeCurrencySum(money: widget.moneyMap[beforeDate.yyyymmdd])
              : 0,
          bankPricePadMap: widget.bankPricePadMap,
          bankPriceTotalPadMap: widget.bankPriceTotalPadMap,
          spendTimePlaceList: (monthlySpendTimePlaceMap[widget.date.yyyymmdd] != null)
              ? monthlySpendTimePlaceMap[widget.date.yyyymmdd]!
              : <SpendTimePlace>[],
          bankNameList: widget.bankNameList,
          emoneyNameList: widget.emoneyNameList,
          spendItemList: widget.spendItemList,
          configMap: widget.configMap,
        ),
      ),
    ];

    for (int i = 1; i < 7; i++) {
      final DateTime day = widget.date.add(Duration(days: i * -1));

      final String youbi = day.youbiStr.substring(0, 3);

      final DateTime beforeDay = DateTime(day.year, day.month, day.day - 1);

      if (widget.moneyMap[day.yyyymmdd] != null) {
        _tabs.add(
          TabInfo(
            '${day.yyyymmdd} ($youbi)',
            DailyMoneyDisplayPage(
              date: day,
              isar: widget.isar,
              moneyList: <Money>[widget.moneyMap[day.yyyymmdd]!],
              onedayMoneyTotal: _utility.makeCurrencySum(money: widget.moneyMap[day.yyyymmdd]),
              beforeMoneyList: (widget.moneyMap[beforeDay.yyyymmdd] != null)
                  ? <Money>[widget.moneyMap[beforeDay.yyyymmdd]!]
                  : <Money>[],
              beforeMoneyTotal: (widget.moneyMap[beforeDay.yyyymmdd] != null)
                  ? _utility.makeCurrencySum(money: widget.moneyMap[beforeDay.yyyymmdd])
                  : 0,
              bankPricePadMap: widget.bankPricePadMap,
              bankPriceTotalPadMap: widget.bankPriceTotalPadMap,
              spendTimePlaceList: (monthlySpendTimePlaceMap[day.yyyymmdd] != null)
                  ? monthlySpendTimePlaceMap[day.yyyymmdd]!
                  : <SpendTimePlace>[],
              bankNameList: widget.bankNameList,
              emoneyNameList: widget.emoneyNameList,
              spendItemList: widget.spendItemList,
              configMap: widget.configMap,
            ),
          ),
        );
      }
    }
  }
}
