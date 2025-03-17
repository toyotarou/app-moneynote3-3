import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/bank_name.dart';
import '../../collections/emoney_name.dart';
import '../../collections/money.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';

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

class _MoneyListAlertState extends ConsumerState<MoneyListAlert> with ControllersMixin<MoneyListAlert> {
  final Utility _utility = Utility();

  final Map<String, Money> _dateMoneyMap = <String, Money>{};

  Map<String, String> _holidayMap = <String, String>{};

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
            children: <Widget>[
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[const Text('月間金額推移'), Text(widget.date.yyyymm)],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              if (widget.moneyList!.isNotEmpty) ...<Widget>[Expanded(child: _dispDateMoneyList())],
              if (widget.moneyList!.isEmpty) ...<Widget>[
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
      for (final Money element in widget.moneyList!) {
        _dateMoneyMap[element.date] = element;
      }
    }
  }

  ///
  Widget _dispDateMoneyList() {
    if (_dateMoneyMap.isEmpty) {
      return const SizedBox.shrink();
    }

    if (holidayState.holidayMap.value != null) {
      _holidayMap = holidayState.holidayMap.value!;
    }

    //---------------------// 見出し行
    final List<Widget> list = <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
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

    final List<Widget> list2 = <Widget>[];

    _dateMoneyMap
      ..forEach((String key, Money value) {
        final DateTime genDate = DateTime.parse('$key 00:00:00');

        if (widget.date.yyyymm == genDate.yyyymm) {
          list.add(DecoratedBox(
            decoration: BoxDecoration(
              color:
                  _utility.getYoubiColor(date: genDate.yyyymmdd, youbiStr: genDate.youbiStr, holidayMap: _holidayMap),
            ),
            child: Row(
              children: <Widget>[
                const SizedBox(height: 20, width: 100),
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
      })
      ..forEach((String key, Money value) {
        final DateTime genDate = DateTime.parse('$key 00:00:00');

        if (widget.date.yyyymm == genDate.yyyymm) {
          list2.add(DecoratedBox(
            decoration: BoxDecoration(
              color:
                  _utility.getYoubiColor(date: genDate.yyyymmdd, youbiStr: genDate.youbiStr, holidayMap: _holidayMap),
            ),
            child: Row(
              children: <Widget>[
                _displayDate(date: genDate),
              ],
            ),
          ));
        }
      });

    return Stack(
      children: <Widget>[
        DefaultTextStyle(
          style: const TextStyle(fontSize: 10),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 36),
              Column(children: list2),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list,
            ),
          ),
        ),
      ],
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
    const int width = 70;
    final Color color = Colors.yellowAccent.withOpacity(0.1);
    const double minHeight = 30.0;

    return Row(
      children: <Widget>[
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
      minHeight: 15,
      color: Colors.transparent,
      borderColor: Colors.white.withOpacity(0.2),
      alignment: Alignment.topLeft,
    );
  }

  ///
  Widget _displayCurrencyList({required Money value}) {
    const int width = 70;
    const Color color = Colors.transparent;

    const double minHeight = 15.0;

    return Row(
      children: <Widget>[
        MoneyListDisplayCell(
          widget: Text(value.yen_10000.toString().toCurrency()),
          width: width.toDouble(),
          minHeight: minHeight,
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.topRight,
        ),
        MoneyListDisplayCell(
          widget: Text(value.yen_5000.toString().toCurrency()),
          width: width.toDouble(),
          minHeight: minHeight,
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.topRight,
        ),
        MoneyListDisplayCell(
          widget: Text(value.yen_2000.toString().toCurrency()),
          width: width.toDouble(),
          minHeight: minHeight,
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.topRight,
        ),
        MoneyListDisplayCell(
          widget: Text(value.yen_1000.toString().toCurrency()),
          width: width.toDouble(),
          minHeight: minHeight,
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.topRight,
        ),
        MoneyListDisplayCell(
          widget: Text(value.yen_500.toString().toCurrency()),
          width: width.toDouble(),
          minHeight: minHeight,
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.topRight,
        ),
        MoneyListDisplayCell(
          widget: Text(value.yen_100.toString().toCurrency()),
          width: width.toDouble(),
          minHeight: minHeight,
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.topRight,
        ),
        MoneyListDisplayCell(
          widget: Text(value.yen_50.toString().toCurrency()),
          width: width.toDouble(),
          minHeight: minHeight,
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.topRight,
        ),
        MoneyListDisplayCell(
          widget: Text(value.yen_10.toString().toCurrency()),
          width: width.toDouble(),
          minHeight: minHeight,
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.topRight,
        ),
        MoneyListDisplayCell(
          widget: Text(value.yen_5.toString().toCurrency()),
          width: width.toDouble(),
          minHeight: minHeight,
          color: color,
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.topRight,
        ),
        MoneyListDisplayCell(
          widget: Text(value.yen_1.toString().toCurrency()),
          width: width.toDouble(),
          minHeight: minHeight,
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
      children: widget.bankNameList!.map((BankName e) {
        return MoneyListDisplayCell(
          widget: Column(children: <Widget>[Text(e.bankName), Text(e.branchName)]),
          width: 100,
          minHeight: 30,
          color: Colors.yellowAccent.withOpacity(0.1),
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.center,
        );
      }).toList(),
    );
  }

  ///
  Widget _displayBankList({required DateTime date}) {
    const double minHeight = 15.0;

    return (widget.bankNameList!.isNotEmpty)
        ? Row(
            children: widget.bankNameList!.map((BankName e) {
              final Map<String, int>? bankPricePadData = widget.bankPricePadMap['${e.depositType}-${e.id}'];

              if (bankPricePadData == null) {
                return MoneyListDisplayCell(
                  widget: const Text('0'),
                  width: 100,
                  minHeight: minHeight,
                  color: Colors.transparent,
                  borderColor: Colors.white.withOpacity(0.2),
                  alignment: Alignment.topRight,
                );
              }

              return MoneyListDisplayCell(
                widget: Text((bankPricePadData[date.yyyymmdd] != null)
                    ? bankPricePadData[date.yyyymmdd].toString().toCurrency()
                    : 0.toString()),
                width: 100,
                minHeight: minHeight,
                color: Colors.transparent,
                borderColor: Colors.white.withOpacity(0.2),
                alignment: Alignment.topRight,
              );
            }).toList(),
          )
        : const SizedBox.shrink();
  }

  ///
  Widget _displayEmoneyMidashi() {
    return Row(
      children: widget.emoneyNameList!.map((EmoneyName e) {
        return MoneyListDisplayCell(
          widget: Text(e.emoneyName),
          width: 100,
          minHeight: 30,
          color: Colors.yellowAccent.withOpacity(0.1),
          borderColor: Colors.white.withOpacity(0.2),
          alignment: Alignment.center,
        );
      }).toList(),
    );
  }

  ///
  Widget _displayEmoneyList({required DateTime date}) {
    const double minHeight = 15.0;

    return (widget.emoneyNameList!.isNotEmpty)
        ? Row(
            children: widget.emoneyNameList!.map((EmoneyName e) {
              final Map<String, int>? bankPricePadData = widget.bankPricePadMap['${e.depositType}-${e.id}'];

              if (bankPricePadData == null) {
                return MoneyListDisplayCell(
                  widget: const Text('0'),
                  width: 100,
                  minHeight: minHeight,
                  color: Colors.transparent,
                  borderColor: Colors.white.withOpacity(0.2),
                  alignment: Alignment.topRight,
                );
              }

              return MoneyListDisplayCell(
                widget: Text((bankPricePadData[date.yyyymmdd] != null)
                    ? bankPricePadData[date.yyyymmdd].toString().toCurrency()
                    : 0.toString()),
                width: 100,
                minHeight: minHeight,
                color: Colors.transparent,
                borderColor: Colors.white.withOpacity(0.2),
                alignment: Alignment.topRight,
              );
            }).toList(),
          )
        : const SizedBox.shrink();
  }
}
