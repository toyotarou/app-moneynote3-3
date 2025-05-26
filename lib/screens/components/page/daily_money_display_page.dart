// ignore_for_file: depend_on_referenced_packages

import 'dart:ui';

import 'package:bubble/bubble.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../collections/bank_name.dart';
import '../../../collections/emoney_name.dart';
import '../../../collections/money.dart';
import '../../../collections/spend_item.dart';
import '../../../collections/spend_time_place.dart';
import '../../../controllers/controllers_mixin.dart';
import '../../../enums/deposit_type.dart';
import '../../../extensions/extensions.dart';

import '../../../utilities/functions.dart';
import '../bank_price_input_alert.dart';
import '../money_input_alert.dart';
import '../parts/bank_emoney_blank_message.dart';
import '../parts/error_dialog.dart';
import '../parts/money_dialog.dart';
import '../spend_time_place_input_alert.dart';

class DailyMoneyDisplayPage extends ConsumerStatefulWidget {
  const DailyMoneyDisplayPage({
    super.key,
    required this.date,
    required this.isar,
    required this.moneyList,
    required this.onedayMoneyTotal,
    required this.beforeMoneyList,
    required this.beforeMoneyTotal,
    required this.bankPricePadMap,
    required this.bankPriceTotalPadMap,
    required this.spendTimePlaceList,
    required this.bankNameList,
    required this.emoneyNameList,
    required this.spendItemList,
    required this.buttonLabelTextList,
  });

  final DateTime date;
  final Isar isar;

  final List<Money> moneyList;
  final int onedayMoneyTotal;

  final List<Money> beforeMoneyList;
  final int beforeMoneyTotal;

  final Map<String, Map<String, int>> bankPricePadMap;
  final Map<String, int> bankPriceTotalPadMap;

  final List<SpendTimePlace> spendTimePlaceList;

  final List<BankName> bankNameList;
  final List<EmoneyName> emoneyNameList;

  final List<SpendItem> spendItemList;

  final List<String> buttonLabelTextList;

  @override
  ConsumerState<DailyMoneyDisplayPage> createState() => _DailyMoneyDisplayAlertState();
}

class _DailyMoneyDisplayAlertState extends ConsumerState<DailyMoneyDisplayPage>
    with ControllersMixin<DailyMoneyDisplayPage> {
  ///
  @override
  Widget build(BuildContext context) {
    final String oneday = widget.date.yyyymmdd;

    final DateTime beforeDate =
        DateTime(oneday.split('-')[0].toInt(), oneday.split('-')[1].toInt(), oneday.split('-')[2].toInt() - 1);

    final int? onedayBankTotal =
        (widget.bankPriceTotalPadMap[oneday] != null) ? widget.bankPriceTotalPadMap[oneday] : 0;
    final int? beforeBankTotal = (widget.bankPriceTotalPadMap[beforeDate.yyyymmdd] != null)
        ? widget.bankPriceTotalPadMap[beforeDate.yyyymmdd]
        : 0;

    final int spendDiff = (widget.beforeMoneyTotal + beforeBankTotal!) - (widget.onedayMoneyTotal + onedayBankTotal!);

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Container(width: context.screenSize.width),
                const SizedBox(height: 20),
                _displayTopInfoPlate(),
                const SizedBox(height: 20),
                _displaySingleMoney(),
                if (widget.buttonLabelTextList.contains('金融機関')) ...<Widget>[
                  const SizedBox(height: 20),
                  _displayBankNames(),
                ],
                if (widget.buttonLabelTextList.contains('電子マネー')) ...<Widget>[
                  const SizedBox(height: 20),
                  _displayEmoneyNames(),
                ],
                const SizedBox(height: 20),
                if (spendDiff != 0) ...<Widget>[
                  _displaySpendTimePlaceList(),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayTopInfoPlate() {
    final String oneday = widget.date.yyyymmdd;

    final DateTime beforeDate =
        DateTime(oneday.split('-')[0].toInt(), oneday.split('-')[1].toInt(), oneday.split('-')[2].toInt() - 1);

    final int? onedayBankTotal =
        (widget.bankPriceTotalPadMap[oneday] != null) ? widget.bankPriceTotalPadMap[oneday] : 0;
    final int? beforeBankTotal = (widget.bankPriceTotalPadMap[beforeDate.yyyymmdd] != null)
        ? widget.bankPriceTotalPadMap[beforeDate.yyyymmdd]
        : 0;

    final int beforeTotal = widget.beforeMoneyTotal + beforeBankTotal!;
    final int onedayTotal = widget.onedayMoneyTotal + onedayBankTotal!;

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(blurRadius: 24, spreadRadius: 16, color: Colors.black.withOpacity(0.2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            width: context.screenSize.width,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Start'),
                      Text(beforeTotal.toString().toCurrency()),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('End'),
                      Text(onedayTotal.toString().toCurrency()),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Spend'),
                      Row(
                        children: <Widget>[
                          _getBubbleComment(beforeTotal: beforeTotal, onedayTotal: onedayTotal),
                          const SizedBox(width: 10),
                          Text(
                            ((widget.beforeMoneyTotal + beforeBankTotal) - (widget.onedayMoneyTotal + onedayBankTotal))
                                .toString()
                                .toCurrency(),
                            style: TextStyle(
                                color: (widget.onedayMoneyTotal == 0) ? const Color(0xFFFBB6CE) : Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _getBubbleComment({required int beforeTotal, required int onedayTotal}) {
    String text = '';
    Color color = Colors.transparent;

    if (beforeTotal > 0 && onedayTotal > beforeTotal) {
      text = '増えた！';
      color = Colors.indigoAccent.withOpacity(0.6);
    }

    if (beforeTotal == 0 && onedayTotal > 0) {
      text = '初日';
      color = Colors.orangeAccent.withOpacity(0.6);
    }

    if (text == '') {
      return const SizedBox.shrink();
    }

    return Row(
      children: <Widget>[
        Bubble(
          color: color,
          nip: BubbleNip.rightTop,
          child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  ///
  Widget _displaySingleMoney() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: context.screenSize.width,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: <Color>[Colors.indigo.withOpacity(0.8), Colors.transparent], stops: const <double>[0.7, 1]),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('CURRENCY', overflow: TextOverflow.ellipsis),
              GestureDetector(
                onTap: () => MoneyDialog(
                  context: context,
                  widget: MoneyInputAlert(
                    date: widget.date,
                    isar: widget.isar,
                    onedayMoneyList: widget.moneyList,
                    beforedayMoneyList: widget.beforeMoneyList,
                  ),
                ),
                child: Icon(Icons.input, color: Colors.greenAccent.withOpacity(0.6)),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox.shrink(),
              Text(
                widget.onedayMoneyTotal.toString().toCurrency(),
                style: const TextStyle(color: Colors.yellowAccent),
              ),
            ],
          ),
        ),
        _displayMoneyParts(key: '10000', value: (widget.moneyList.isNotEmpty) ? widget.moneyList[0].yen_10000 : 0),
        _displayMoneyParts(key: '5000', value: (widget.moneyList.isNotEmpty) ? widget.moneyList[0].yen_5000 : 0),
        _displayMoneyParts(key: '2000', value: (widget.moneyList.isNotEmpty) ? widget.moneyList[0].yen_2000 : 0),
        _displayMoneyParts(key: '1000', value: (widget.moneyList.isNotEmpty) ? widget.moneyList[0].yen_1000 : 0),
        _displayMoneyParts(key: '500', value: (widget.moneyList.isNotEmpty) ? widget.moneyList[0].yen_500 : 0),
        _displayMoneyParts(key: '100', value: (widget.moneyList.isNotEmpty) ? widget.moneyList[0].yen_100 : 0),
        _displayMoneyParts(key: '50', value: (widget.moneyList.isNotEmpty) ? widget.moneyList[0].yen_50 : 0),
        _displayMoneyParts(key: '10', value: (widget.moneyList.isNotEmpty) ? widget.moneyList[0].yen_10 : 0),
        _displayMoneyParts(key: '5', value: (widget.moneyList.isNotEmpty) ? widget.moneyList[0].yen_5 : 0),
        _displayMoneyParts(key: '1', value: (widget.moneyList.isNotEmpty) ? widget.moneyList[0].yen_1 : 0),
        const SizedBox(height: 20),
      ],
    );
  }

  ///
  Widget _displayMoneyParts({required String key, required int value}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[Text(key), Text(value.toString().toCurrency())],
      ),
    );
  }

  ///
  Widget _displayBankNames() {
    final List<Widget> list = <Widget>[
      Container(
        width: context.screenSize.width,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[Colors.indigo.withOpacity(0.8), Colors.transparent], stops: const <double>[0.7, 1]),
        ),
        child: const Text('BANK', overflow: TextOverflow.ellipsis),
      )
    ];

    if (widget.bankNameList.isEmpty) {
      list.add(
        Column(
          children: <Widget>[
            const SizedBox(height: 10),
            BankEmoneyBlankMessage(
              deposit: '金融機関',
              isar: widget.isar,
              buttonLabelTextList: widget.buttonLabelTextList,
            ),
            const SizedBox(height: 30),
          ],
        ),
      );
    } else {
      final List<Widget> list2 = <Widget>[];

      int sum = 0;

      for (int i = 0; i < widget.bankNameList.length; i++) {
        if (widget.bankPricePadMap['${widget.bankNameList[i].depositType}-${widget.bankNameList[i].id}'] != null) {
          final Map<String, int>? bankPriceMap =
              widget.bankPricePadMap['${widget.bankNameList[i].depositType}-${widget.bankNameList[i].id}'];
          if (bankPriceMap![widget.date.yyyymmdd] != null) {
            sum += bankPriceMap[widget.date.yyyymmdd]!;
          }
        }
      }

      list2.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox.shrink(),
              Text(sum.toString().toCurrency(), style: const TextStyle(color: Colors.yellowAccent)),
            ],
          ),
        ),
      );

      for (int i = 0; i < widget.bankNameList.length; i++) {
        list2.add(
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.bankNameList[i].bankName, maxLines: 2, overflow: TextOverflow.ellipsis),
                      Text(widget.bankNameList[i].branchName, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          _getListPrice(depositType: widget.bankNameList[i].depositType, id: widget.bankNameList[i].id)
                              .toString()
                              .toCurrency(),
                        ),
                        Text(
                          _getListDate(depositType: widget.bankNameList[i].depositType, id: widget.bankNameList[i].id),
                          style: TextStyle(color: Colors.grey.withOpacity(0.6)),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        appParamNotifier.setSelectedBankPriceYear(year: '');

                        MoneyDialog(
                          context: context,
                          widget: BankPriceInputAlert(
                            date: widget.date,
                            isar: widget.isar,
                            depositType: DepositType.bank,
                            bankName: widget.bankNameList[i],
                            from: 'DailyMoneyDisplayPage',
                          ),
                        );
                      },
                      child: Icon(Icons.input, color: Colors.greenAccent.withOpacity(0.6)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      list.add(Column(children: list2));
    }

    return Column(children: list);
  }

  ///
  Widget _displayEmoneyNames() {
    final List<Widget> list = <Widget>[
      Container(
        width: context.screenSize.width,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[Colors.indigo.withOpacity(0.8), Colors.transparent], stops: const <double>[0.7, 1]),
        ),
        child: const Text('E-MONEY', overflow: TextOverflow.ellipsis),
      )
    ];

    if (widget.emoneyNameList.isEmpty) {
      list.add(
        Column(
          children: <Widget>[
            const SizedBox(height: 10),
            BankEmoneyBlankMessage(
              deposit: '電子マネー',
              index: 1,
              isar: widget.isar,
              buttonLabelTextList: widget.buttonLabelTextList,
            ),
            const SizedBox(height: 30),
          ],
        ),
      );
    } else {
      final List<Widget> list2 = <Widget>[];

      int sum = 0;

      for (int i = 0; i < widget.emoneyNameList.length; i++) {
        if (widget.bankPricePadMap['${widget.emoneyNameList[i].depositType}-${widget.emoneyNameList[i].id}'] != null) {
          final Map<String, int>? bankPriceMap =
              widget.bankPricePadMap['${widget.emoneyNameList[i].depositType}-${widget.emoneyNameList[i].id}'];

          if (bankPriceMap![widget.date.yyyymmdd] != null) {
            sum += bankPriceMap[widget.date.yyyymmdd]!;
          }
        }
      }

      list2.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox.shrink(),
              Text(sum.toString().toCurrency(), style: const TextStyle(color: Colors.yellowAccent)),
            ],
          ),
        ),
      );

      for (int i = 0; i < widget.emoneyNameList.length; i++) {
        list2.add(
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Text(widget.emoneyNameList[i].emoneyName, maxLines: 2, overflow: TextOverflow.ellipsis)),
                Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          _getListPrice(
                                  depositType: widget.emoneyNameList[i].depositType, id: widget.emoneyNameList[i].id)
                              .toString()
                              .toCurrency(),
                        ),
                        Text(
                          _getListDate(
                              depositType: widget.emoneyNameList[i].depositType, id: widget.emoneyNameList[i].id),
                          style: TextStyle(color: Colors.grey.withOpacity(0.6)),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        appParamNotifier.setSelectedBankPriceYear(year: '');

                        MoneyDialog(
                          context: context,
                          widget: BankPriceInputAlert(
                            date: widget.date,
                            isar: widget.isar,
                            depositType: DepositType.emoney,
                            emoneyName: widget.emoneyNameList[i],
                            from: 'DailyMoneyDisplayPage',
                          ),
                        );
                      },
                      child: Icon(Icons.input, color: Colors.greenAccent.withOpacity(0.6)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      list.add(Column(children: list2));
    }

    return Column(children: list);
  }

  ///
  int _getListPrice({required String depositType, required int id}) {
    int listPrice = 0;
    if (widget.bankPricePadMap['$depositType-$id'] != null) {
      final Map<String, int>? bankPriceMap = widget.bankPricePadMap['$depositType-$id'];
      if (bankPriceMap![widget.date.yyyymmdd] != null) {
        listPrice = bankPriceMap[widget.date.yyyymmdd]!;
      }
    }

    return listPrice;
  }

  ///
  String _getListDate({required String depositType, required Id id}) {
    String listDate = '';

    if (widget.bankPricePadMap['$depositType-$id'] != null) {
      final Map<String, int>? bankPriceMap = widget.bankPricePadMap['$depositType-$id'];

      int keepPrice = -1;

      bankPriceMap?.forEach(
        (String key, int value) {
          if (keepPrice != value) {
            listDate = key;
          }

          keepPrice = value;
        },
      );
    }

    return listDate;
  }

  ///
  Widget _displaySpendTimePlaceList() {
    final List<Widget> list = <Widget>[
      Column(
        children: <Widget>[
          Container(
            width: context.screenSize.width,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: <Color>[Colors.indigo.withOpacity(0.8), Colors.transparent], stops: const <double>[0.7, 1]),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('SPEND', overflow: TextOverflow.ellipsis),
                GestureDetector(
                  onTap: () async {
                    if (widget.onedayMoneyTotal == 0) {
                      // ignore: always_specify_types
                      Future.delayed(
                        Duration.zero,
                        () => error_dialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            title: '登録できません。',
                            content: '先にCURRENCYを入力してください。'),
                      );

                      return;
                    }

                    final String oneday = widget.date.yyyymmdd;

                    final DateTime beforeDate = DateTime(
                        oneday.split('-')[0].toInt(), oneday.split('-')[1].toInt(), oneday.split('-')[2].toInt() - 1);

                    final int? onedayBankTotal =
                        (widget.bankPriceTotalPadMap[oneday] != null) ? widget.bankPriceTotalPadMap[oneday] : 0;
                    final int? beforeBankTotal = (widget.bankPriceTotalPadMap[beforeDate.yyyymmdd] != null)
                        ? widget.bankPriceTotalPadMap[beforeDate.yyyymmdd]
                        : 0;

                    appParamNotifier.setInputButtonClicked(flag: false);

                    if (mounted) {
                      await MoneyDialog(
                        context: context,
                        widget: SpendTimePlaceInputAlert(
                          date: widget.date,
                          spend: (widget.beforeMoneyTotal + beforeBankTotal!) -
                              (widget.onedayMoneyTotal + onedayBankTotal!),
                          isar: widget.isar,
                          spendTimePlaceList: widget.spendTimePlaceList,
                        ),
                      );
                    }
                  },
                  child: Icon(Icons.input, color: Colors.greenAccent.withOpacity(0.6)),
                ),
              ],
            ),
          ),
        ],
      ),
    ];

    if (widget.spendTimePlaceList.isNotEmpty) {
      final Map<String, String> spendItemColorMap = <String, String>{};
      if (widget.spendItemList.isNotEmpty) {
        for (final SpendItem element in widget.spendItemList) {
          spendItemColorMap[element.spendItemName] = element.color;
        }
      }

      int sum = 0;
      makeMonthlySpendItemSumMap(spendItemList: widget.spendItemList, spendTimePlaceList: widget.spendTimePlaceList)
          .forEach((String key, int value) => sum += value);

      list.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox.shrink(),
              Text(sum.toString().toCurrency(), style: const TextStyle(color: Colors.yellowAccent)),
            ],
          ),
        ),
      );

      makeMonthlySpendItemSumMap(spendTimePlaceList: widget.spendTimePlaceList, spendItemList: widget.spendItemList)
          .forEach(
        (String key, int value) {
          final String? lineColor =
              (spendItemColorMap[key] != null && spendItemColorMap[key] != '') ? spendItemColorMap[key] : '0xffffffff';

          list.add(
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FittedBox(child: Text(key, style: TextStyle(color: Color(lineColor!.toInt())))),
                  Text(value.toString().toCurrency(), style: TextStyle(color: Color(lineColor.toInt()))),
                ],
              ),
            ),
          );
        },
      );
    }

    return Column(mainAxisSize: MainAxisSize.min, children: list);
  }
}
