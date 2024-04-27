import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/bank_name.dart';
import '../../collections/emoney_name.dart';
import '../../collections/money.dart';
import '../../extensions/extensions.dart';
import '../../state/holidays/holidays_notifier.dart';
import '../../utilities/utilities.dart';
import 'parts/money_list_display_cell.dart';

class MoneyListAlert extends ConsumerStatefulWidget {
  const MoneyListAlert({
    super.key,
    required this.date,
    required this.isar,
    this.moneyList,
    this.bankNameList,
    this.emoneyNameList,
    required this.bankPricePadMap,
  });

  final DateTime date;
  final Isar isar;

  final List<Money>? moneyList;

  final List<BankName>? bankNameList;
  final List<EmoneyName>? emoneyNameList;

  final Map<String, Map<String, int>> bankPricePadMap;

  @override
  ConsumerState<MoneyListAlert> createState() => _MoneyListAlertState();
}

class _MoneyListAlertState extends ConsumerState<MoneyListAlert> {
  final Utility _utility = Utility();

  final Map<String, Money> _dateMoneyMap = {};

  Map<String, String> _holidayMap = {};

  final int _midashiDivide = 35;

  ///
  @override
  void initState() {
    super.initState();

    _makeDateMoneyMap();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: DefaultTextStyle(
          style: GoogleFonts.kiwiMaru(fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('月間金額推移'), Text(widget.date.yyyymm)],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              if (widget.moneyList!.isNotEmpty) ...[Expanded(child: _dispDateMoneyList())],
              if (widget.moneyList!.isEmpty) ...[
                const Text('no data', style: TextStyle(color: Colors.yellowAccent, fontSize: 12)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  ///
  void _makeDateMoneyMap() {
    if (widget.moneyList!.isNotEmpty) {
      widget.moneyList!.forEach((element) {
        _dateMoneyMap[element.date] = element;
      });
    }
  }

  ///
  Widget _dispDateMoneyList() {
    if (_dateMoneyMap.isEmpty) {
      return Container();
    }

    final holidayState = ref.watch(holidayProvider);

    if (holidayState.holidayMap.value != null) {
      _holidayMap = holidayState.holidayMap.value!;
    }

    //---------------------// 見出し行
    final list = <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _displayBlank(),
          const SizedBox(width: 10),
          _displayCurrencyMidashi(),
          const SizedBox(width: 10),
          _displayBankMidashi(),
          const SizedBox(width: 10),
          _displayEmoneyMidashi(),
        ],
      )
    ];
    //---------------------// 見出し行

    _dateMoneyMap.forEach((key, value) {
      final genDate = DateTime.parse('$key 00:00:00');

      if (widget.date.yyyymm == genDate.yyyymm) {
        list.add(DecoratedBox(
          decoration: BoxDecoration(
            color: _utility.getYoubiColor(date: genDate.yyyymmdd, youbiStr: genDate.youbiStr, holidayMap: _holidayMap),
          ),
          child: Row(
            children: [
              _displayDate(date: genDate),
              const SizedBox(width: 10),
              _displayCurrencyList(value: value),
              const SizedBox(width: 10),
              _displayBankList(date: genDate),
              const SizedBox(width: 10),
              _displayEmoneyList(date: genDate),
            ],
          ),
        ));
      }
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: list,
        ),
      ),
    );
  }

  ///
  Widget _displayBlank() {
    return const MoneyListDisplayCell(
      widget: Text(''),
      width: 100,
      color: Colors.transparent,
      borderColor: Colors.transparent,
      alignment: Alignment.topLeft,
    );
  }

  ///
  Widget _displayCurrencyMidashi() {
    const width = 70;
    final color = Colors.yellowAccent.withOpacity(0.1);
    final minHeight = context.screenSize.height / _midashiDivide;

    return Row(
      children: [
        MoneyListDisplayCell(
          widget: const Text('10000'),
          width: width.toDouble(),
          minHeight: minHeight,
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.center,
        ),
        MoneyListDisplayCell(
          widget: const Text('5000'),
          width: width.toDouble(),
          minHeight: minHeight,
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.center,
        ),
        MoneyListDisplayCell(
          widget: const Text('2000'),
          width: width.toDouble(),
          minHeight: minHeight,
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.center,
        ),
        MoneyListDisplayCell(
          widget: const Text('1000'),
          width: width.toDouble(),
          minHeight: minHeight,
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.center,
        ),
        MoneyListDisplayCell(
          widget: const Text('500'),
          width: width.toDouble(),
          minHeight: minHeight,
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.center,
        ),
        MoneyListDisplayCell(
          widget: const Text('100'),
          width: width.toDouble(),
          minHeight: minHeight,
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.center,
        ),
        MoneyListDisplayCell(
          widget: const Text('50'),
          width: width.toDouble(),
          minHeight: minHeight,
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.center,
        ),
        MoneyListDisplayCell(
          widget: const Text('10'),
          width: width.toDouble(),
          minHeight: minHeight,
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.center,
        ),
        MoneyListDisplayCell(
          widget: const Text('5'),
          width: width.toDouble(),
          minHeight: minHeight,
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.center,
        ),
        MoneyListDisplayCell(
          widget: const Text('1'),
          width: width.toDouble(),
          minHeight: minHeight,
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.center,
        ),
      ],
    );
  }

  ///
  Widget _displayDate({required DateTime date}) {
    return MoneyListDisplayCell(
      widget: Text('${date.yyyymmdd}（${date.youbiStr.substring(0, 3)}）'),
      width: 100,
      color: Colors.transparent,
      borderColor: Colors.white.withOpacity(0.2),
      alignment: Alignment.topLeft,
    );
  }

  ///
  Widget _displayCurrencyList({required Money value}) {
    const width = 70;
    const color = Colors.transparent;

    return Row(
      children: [
        MoneyListDisplayCell(
          widget: Text(value.yen_10000.toString().toCurrency()),
          width: width.toDouble(),
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.topRight,
        ),
        MoneyListDisplayCell(
          widget: Text(value.yen_5000.toString().toCurrency()),
          width: width.toDouble(),
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.topRight,
        ),
        MoneyListDisplayCell(
          widget: Text(value.yen_2000.toString().toCurrency()),
          width: width.toDouble(),
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.topRight,
        ),
        MoneyListDisplayCell(
          widget: Text(value.yen_1000.toString().toCurrency()),
          width: width.toDouble(),
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.topRight,
        ),
        MoneyListDisplayCell(
          widget: Text(value.yen_500.toString().toCurrency()),
          width: width.toDouble(),
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.topRight,
        ),
        MoneyListDisplayCell(
          widget: Text(value.yen_100.toString().toCurrency()),
          width: width.toDouble(),
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.topRight,
        ),
        MoneyListDisplayCell(
          widget: Text(value.yen_50.toString().toCurrency()),
          width: width.toDouble(),
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.topRight,
        ),
        MoneyListDisplayCell(
          widget: Text(value.yen_10.toString().toCurrency()),
          width: width.toDouble(),
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.topRight,
        ),
        MoneyListDisplayCell(
          widget: Text(value.yen_5.toString().toCurrency()),
          width: width.toDouble(),
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.topRight,
        ),
        MoneyListDisplayCell(
          widget: Text(value.yen_1.toString().toCurrency()),
          width: width.toDouble(),
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.topRight,
        ),
      ],
    );
  }

  ///
  Widget _displayBankMidashi() {
    return Row(
      children: widget.bankNameList!.map((e) {
        return MoneyListDisplayCell(
          widget: Column(children: [Text(e.bankName), Text(e.branchName)]),
          width: 100,
          minHeight: context.screenSize.height / _midashiDivide,
          color: Colors.yellowAccent.withOpacity(0.1),
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.center,
        );
      }).toList(),
    );
  }

  ///
  Widget _displayBankList({required DateTime date}) {
    return (widget.bankNameList!.isNotEmpty)
        ? Row(
            children: widget.bankNameList!.map((e) {
              final bankPricePadData = widget.bankPricePadMap['${e.depositType}-${e.id}'];

              if (bankPricePadData == null) {
                return MoneyListDisplayCell(
                  widget: const Text('0'),
                  width: 100,
                  color: Colors.transparent,
                  borderColor: Colors.white.withOpacity(0.2),
                  alignment: Alignment.topRight,
                );
              }

              return MoneyListDisplayCell(
                widget: Text((bankPricePadData[date.yyyymmdd] != null) ? bankPricePadData[date.yyyymmdd].toString().toCurrency() : 0.toString()),
                width: 100,
                color: Colors.transparent,
                borderColor: Colors.white.withOpacity(0.2),
                alignment: Alignment.topRight,
              );
            }).toList(),
          )
        : Container();
  }

  ///
  Widget _displayEmoneyMidashi() {
    return Row(
      children: widget.emoneyNameList!.map((e) {
        return MoneyListDisplayCell(
          widget: Text(e.emoneyName),
          width: 100,
          minHeight: context.screenSize.height / _midashiDivide,
          color: Colors.yellowAccent.withOpacity(0.1),
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.center,
        );
      }).toList(),
    );
  }

  ///
  Widget _displayEmoneyList({required DateTime date}) {
    return (widget.emoneyNameList!.isNotEmpty)
        ? Row(
            children: widget.emoneyNameList!.map((e) {
              final bankPricePadData = widget.bankPricePadMap['${e.depositType}-${e.id}'];

              if (bankPricePadData == null) {
                return MoneyListDisplayCell(
                  widget: const Text('0'),
                  width: 100,
                  color: Colors.transparent,
                  borderColor: Colors.white.withOpacity(0.2),
                  alignment: Alignment.topRight,
                );
              }

              return MoneyListDisplayCell(
                widget: Text((bankPricePadData[date.yyyymmdd] != null) ? bankPricePadData[date.yyyymmdd].toString().toCurrency() : 0.toString()),
                width: 100,
                color: Colors.transparent,
                borderColor: Colors.white.withOpacity(0.2),
                alignment: Alignment.topRight,
              );
            }).toList(),
          )
        : Container();
  }
}
