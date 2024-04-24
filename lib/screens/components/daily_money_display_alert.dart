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

  @override
  ConsumerState<DailyMoneyDisplayAlert> createState() => _DailyMoneyDisplayAlertState();
}

class _DailyMoneyDisplayAlertState extends ConsumerState<DailyMoneyDisplayAlert> {
  final Utility _utility = Utility();

  List<TabInfo> _tabs = [];

  Map<String, List<SpendTimePlace>> monthlySpendTimePlaceMap = {};

  ///
  @override
  void initState() {
    super.initState();

    widget.prevMonthSpendTimePlaceList.forEach((element) => monthlySpendTimePlaceMap[element.date] = []);
    widget.thisMonthSpendTimePlaceList.forEach((element) => monthlySpendTimePlaceMap[element.date] = []);

    widget.prevMonthSpendTimePlaceList.forEach((element) => monthlySpendTimePlaceMap[element.date]?.add(element));
    widget.thisMonthSpendTimePlaceList.forEach((element) => monthlySpendTimePlaceMap[element.date]?.add(element));
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
        body: TabBarView(children: _tabs.map((tab) => tab.widget).toList()),
      ),
    );
  }

  ///
  void _makeTab() {
    final beforeDate = DateTime(widget.date.year, widget.date.month, widget.date.day - 1);

    _tabs = [
      TabInfo(
        '${widget.date.yyyymmdd} (${widget.date.youbiStr.substring(0, 3)})',
        DailyMoneyDisplayPage(
          date: widget.date,
          isar: widget.isar,
          moneyList: (widget.moneyMap[widget.date.yyyymmdd] != null) ? [widget.moneyMap[widget.date.yyyymmdd]!] : [],
          onedayMoneyTotal:
              (widget.moneyMap[widget.date.yyyymmdd] != null) ? _utility.makeCurrencySum(money: widget.moneyMap[widget.date.yyyymmdd]) : 0,
          beforeMoneyList: (widget.moneyMap[beforeDate.yyyymmdd] != null) ? [widget.moneyMap[beforeDate.yyyymmdd]!] : [],
          beforeMoneyTotal:
              (widget.moneyMap[beforeDate.yyyymmdd] != null) ? _utility.makeCurrencySum(money: widget.moneyMap[beforeDate.yyyymmdd]) : 0,
          bankPricePadMap: widget.bankPricePadMap,
          bankPriceTotalPadMap: widget.bankPriceTotalPadMap,
          spendTimePlaceList: (monthlySpendTimePlaceMap[widget.date.yyyymmdd] != null) ? monthlySpendTimePlaceMap[widget.date.yyyymmdd]! : [],
          bankNameList: widget.bankNameList,
          emoneyNameList: widget.emoneyNameList,
          spendItemList: widget.spendItemList,
        ),
      ),
    ];

    for (var i = 1; i < 7; i++) {
      final day = widget.date.add(Duration(days: i * -1));

      final youbi = day.youbiStr.substring(0, 3);

      final beforeDay = DateTime(day.year, day.month, day.day - 1);

      if (widget.moneyMap[day.yyyymmdd] != null) {
        _tabs.add(
          TabInfo(
            '${day.yyyymmdd} ($youbi)',
            DailyMoneyDisplayPage(
              date: day,
              isar: widget.isar,
              moneyList: [widget.moneyMap[day.yyyymmdd]!],
              onedayMoneyTotal: _utility.makeCurrencySum(money: widget.moneyMap[day.yyyymmdd]),
              beforeMoneyList: (widget.moneyMap[beforeDay.yyyymmdd] != null) ? [widget.moneyMap[beforeDay.yyyymmdd]!] : [],
              beforeMoneyTotal:
                  (widget.moneyMap[beforeDay.yyyymmdd] != null) ? _utility.makeCurrencySum(money: widget.moneyMap[beforeDay.yyyymmdd]) : 0,
              bankPricePadMap: widget.bankPricePadMap,
              bankPriceTotalPadMap: widget.bankPriceTotalPadMap,
              spendTimePlaceList: (monthlySpendTimePlaceMap[day.yyyymmdd] != null) ? monthlySpendTimePlaceMap[day.yyyymmdd]! : [],
              bankNameList: widget.bankNameList,
              emoneyNameList: widget.emoneyNameList,
              spendItemList: widget.spendItemList,
            ),
          ),
        );
      }
    }
  }
}
