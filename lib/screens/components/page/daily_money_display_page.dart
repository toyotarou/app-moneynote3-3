import 'dart:ui';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../collections/bank_name.dart';
import '../../../collections/bank_price.dart';
import '../../../collections/emoney_name.dart';
import '../../../collections/income.dart';
import '../../../collections/money.dart';
import '../../../collections/spend_item.dart';
import '../../../collections/spend_time_place.dart';
import '../../../enums/deposit_type.dart';
import '../../../extensions/extensions.dart';
import '../../../repository/bank_names_repository.dart';
import '../../../repository/bank_prices_repository.dart';
import '../../../repository/emoney_names_repository.dart';
import '../../../repository/incomes_repository.dart';
import '../../../repository/moneys_repository.dart';
import '../../../repository/spend_items_repository.dart';
import '../../../repository/spend_time_places_repository.dart';
import '../../../state/app_params/app_params_notifier.dart';
import '../../../utilities/functions.dart';
import '../../../utilities/utilities.dart';
import '../bank_price_input_alert.dart';
import '../money_input_alert.dart';
import '../parts/bank_emoney_blank_message.dart';
import '../parts/error_dialog.dart';
import '../parts/money_dialog.dart';
import '../spend_time_place_input_alert.dart';

class DailyMoneyDisplayPage extends ConsumerStatefulWidget {
  const DailyMoneyDisplayPage({super.key, required this.date, required this.isar});

  final DateTime date;
  final Isar isar;

  @override
  ConsumerState<DailyMoneyDisplayPage> createState() => _DailyMoneyDisplayAlertState();
}

class _DailyMoneyDisplayAlertState extends ConsumerState<DailyMoneyDisplayPage> {
  final Utility _utility = Utility();

  // ignore: use_late_for_private_fields_and_variables
  List<BankName>? _bankNameList = [];

  // ignore: use_late_for_private_fields_and_variables
  List<EmoneyName>? _emoneyNameList = [];

  List<BankPrice>? bankPriceList = [];
  List<Money>? _moneyList = [];
  List<Money>? _beforeMoneyList = [];
  List<SpendTimePlace>? _spendTimePlaceList = [];

  Map<String, Map<String, int>> _bankPricePadMap = {};
  Map<String, int> _bankPriceTotalPadMap = {};

  int _onedayMoneyTotal = 0;
  int _beforeMoneyTotal = 0;

  final Map<String, Income> _incomeMap = {};

  List<SpendItem>? _spendItemList = [];

  ///
  void _init() {
    _makeBankNameList();
    _makeEmoneyNameList();

    _makeBankPriceList();
    _makeMoneyList();
    _makeBeforeMoneyList();

    _makeIncomeMap();

    _makeSpendTimePlaceList();

    _makeSpendItemList();
  }

  ///
  @override
  Widget build(BuildContext context) {
    Future(_init);

    final oneday = widget.date.yyyymmdd;

    final beforeDate =
        DateTime(oneday.split('-')[0].toInt(), oneday.split('-')[1].toInt(), oneday.split('-')[2].toInt() - 1);

    final onedayBankTotal = (_bankPriceTotalPadMap[oneday] != null) ? _bankPriceTotalPadMap[oneday] : 0;
    final beforeBankTotal =
        (_bankPriceTotalPadMap[beforeDate.yyyymmdd] != null) ? _bankPriceTotalPadMap[beforeDate.yyyymmdd] : 0;

    final spendDiff = (_beforeMoneyTotal + beforeBankTotal!) - (_onedayMoneyTotal + onedayBankTotal!);

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
              children: [
                const SizedBox(height: 20),
                Container(width: context.screenSize.width),
                const SizedBox(height: 20),
                _displayTopInfoPlate(),
                const SizedBox(height: 20),
                _displaySingleMoney(),
                const SizedBox(height: 20),
                _displayBankNames(),
                const SizedBox(height: 20),
                _displayEmoneyNames(),
                const SizedBox(height: 20),
                if (spendDiff != 0) ...[
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
    final oneday = widget.date.yyyymmdd;

    final beforeDate =
        DateTime(oneday.split('-')[0].toInt(), oneday.split('-')[1].toInt(), oneday.split('-')[2].toInt() - 1);

    final onedayBankTotal = (_bankPriceTotalPadMap[oneday] != null) ? _bankPriceTotalPadMap[oneday] : 0;
    final beforeBankTotal =
        (_bankPriceTotalPadMap[beforeDate.yyyymmdd] != null) ? _bankPriceTotalPadMap[beforeDate.yyyymmdd] : 0;

    final beforeTotal = _beforeMoneyTotal + beforeBankTotal!;
    final onedayTotal = _onedayMoneyTotal + onedayBankTotal!;

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
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
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                    children: [
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
                    children: [
                      const Text('Spend'),
                      Row(
                        children: [
                          _getBubbleComment(beforeTotal: beforeTotal, onedayTotal: onedayTotal),
                          const SizedBox(width: 10),
                          Text(
                            ((_beforeMoneyTotal + beforeBankTotal) - (_onedayMoneyTotal + onedayBankTotal))
                                .toString()
                                .toCurrency(),
                            style: TextStyle(color: (_onedayMoneyTotal == 0) ? const Color(0xFFFBB6CE) : Colors.white),
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
    var text = '';
    var color = Colors.transparent;

    if (beforeTotal > 0 && onedayTotal > beforeTotal) {
      text = '増えた！';
      color = Colors.indigoAccent.withOpacity(0.6);
    }

    if (beforeTotal == 0 && onedayTotal > 0) {
      text = '初日';
      color = Colors.orangeAccent.withOpacity(0.6);
    }

    if (text == '') {
      return Container();
    }

    return Row(
      children: [
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
      children: [
        Container(
          width: context.screenSize.width,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.indigo.withOpacity(0.8), Colors.transparent], stops: const [0.7, 1]),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('CURRENCY', overflow: TextOverflow.ellipsis),
              GestureDetector(
                onTap: () => MoneyDialog(
                  context: context,
                  widget: MoneyInputAlert(
                    date: widget.date,
                    isar: widget.isar,
                    onedayMoneyList: _moneyList,
                    beforedayMoneyList: _beforeMoneyList,
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
            children: [
              Container(),
              Text(
                _onedayMoneyTotal.toString().toCurrency(),
                style: const TextStyle(color: Colors.yellowAccent),
              ),
            ],
          ),
        ),
        _displayMoneyParts(key: '10000', value: (_moneyList!.isNotEmpty) ? _moneyList![0].yen_10000 : 0),
        _displayMoneyParts(key: '5000', value: (_moneyList!.isNotEmpty) ? _moneyList![0].yen_5000 : 0),
        _displayMoneyParts(key: '2000', value: (_moneyList!.isNotEmpty) ? _moneyList![0].yen_2000 : 0),
        _displayMoneyParts(key: '1000', value: (_moneyList!.isNotEmpty) ? _moneyList![0].yen_1000 : 0),
        _displayMoneyParts(key: '500', value: (_moneyList!.isNotEmpty) ? _moneyList![0].yen_500 : 0),
        _displayMoneyParts(key: '100', value: (_moneyList!.isNotEmpty) ? _moneyList![0].yen_100 : 0),
        _displayMoneyParts(key: '50', value: (_moneyList!.isNotEmpty) ? _moneyList![0].yen_50 : 0),
        _displayMoneyParts(key: '10', value: (_moneyList!.isNotEmpty) ? _moneyList![0].yen_10 : 0),
        _displayMoneyParts(key: '5', value: (_moneyList!.isNotEmpty) ? _moneyList![0].yen_5 : 0),
        _displayMoneyParts(key: '1', value: (_moneyList!.isNotEmpty) ? _moneyList![0].yen_1 : 0),
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
        children: [Text(key), Text(value.toString().toCurrency())],
      ),
    );
  }

  ///
  Future<void> _makeMoneyList() async {
    final param = <String, dynamic>{};
    param['date'] = widget.date.yyyymmdd;

    await MoneysRepository().getDateMoneyList(isar: widget.isar, param: param).then((value) {
      setState(() {
        _moneyList = value;

        if (value!.isNotEmpty) {
          _onedayMoneyTotal = _utility.makeCurrencySum(money: value[0]);
        }
      });
    });
  }

  ///
  Future<void> _makeBeforeMoneyList() async {
    final param = <String, dynamic>{};

    final oneday = widget.date.yyyymmdd;

    final beforeDate =
        DateTime(oneday.split('-')[0].toInt(), oneday.split('-')[1].toInt(), oneday.split('-')[2].toInt() - 1);

    param['date'] = beforeDate.yyyymmdd;

    await MoneysRepository().getDateMoneyList(isar: widget.isar, param: param).then((value) {
      if (mounted) {
        setState(() {
          _beforeMoneyList = value;

          if (value!.isNotEmpty) {
            _beforeMoneyTotal = _utility.makeCurrencySum(money: value[0]);
          }
        });
      }
    });
  }

  ///
  Future<void> _makeBankNameList() async => await BankNamesRepository()
      .getBankNameList(isar: widget.isar)
      .then((value) => setState(() => _bankNameList = value));

  ///
  Widget _displayBankNames() {
    final list = <Widget>[
      Container(
        width: context.screenSize.width,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.indigo.withOpacity(0.8), Colors.transparent], stops: const [0.7, 1]),
        ),
        child: const Text('BANK', overflow: TextOverflow.ellipsis),
      )
    ];

    if (_bankNameList!.isEmpty) {
      list.add(Column(
        children: [
          const SizedBox(height: 10),
          BankEmoneyBlankMessage(deposit: '金融機関', isar: widget.isar),
          const SizedBox(height: 30),
        ],
      ));
    } else {
      final list2 = <Widget>[];

      var sum = 0;
      for (var i = 0; i < _bankNameList!.length; i++) {
        if (_bankPricePadMap['${_bankNameList![i].depositType}-${_bankNameList![i].id}'] != null) {
          final bankPriceMap = _bankPricePadMap['${_bankNameList![i].depositType}-${_bankNameList![i].id}'];
          if (bankPriceMap![widget.date.yyyymmdd] != null) {
            sum += bankPriceMap[widget.date.yyyymmdd]!;
          }
        }
      }

      list2.add(Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Text(sum.toString().toCurrency(), style: const TextStyle(color: Colors.yellowAccent)),
          ],
        ),
      ));

      for (var i = 0; i < _bankNameList!.length; i++) {
        list2.add(
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(_bankNameList![i].bankName), Text(_bankNameList![i].branchName)],
                ),
                Row(
                  children: [
                    Text(
                      _getListPrice(depositType: _bankNameList![i].depositType, id: _bankNameList![i].id)
                          .toString()
                          .toCurrency(),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => MoneyDialog(
                        context: context,
                        widget: BankPriceInputAlert(
                          date: widget.date,
                          isar: widget.isar,
                          depositType: DepositType.bank,
                          bankName: _bankNameList![i],
                        ),
                      ),
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
  Future<void> _makeEmoneyNameList() async => await EmoneyNamesRepository()
      .getEmoneyNameList(isar: widget.isar)
      .then((value) => setState(() => _emoneyNameList = value));

  ///
  Widget _displayEmoneyNames() {
    final list = <Widget>[
      Container(
        width: context.screenSize.width,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.indigo.withOpacity(0.8), Colors.transparent], stops: const [0.7, 1]),
        ),
        child: const Text('E-MONEY', overflow: TextOverflow.ellipsis),
      )
    ];

    if (_emoneyNameList!.isEmpty) {
      list.add(Column(
        children: [
          const SizedBox(height: 10),
          BankEmoneyBlankMessage(deposit: '電子マネー', index: 1, isar: widget.isar),
          const SizedBox(height: 30),
        ],
      ));
    } else {
      final list2 = <Widget>[];

      var sum = 0;
      for (var i = 0; i < _emoneyNameList!.length; i++) {
        if (_bankPricePadMap['${_emoneyNameList![i].depositType}-${_emoneyNameList![i].id}'] != null) {
          final bankPriceMap = _bankPricePadMap['${_emoneyNameList![i].depositType}-${_emoneyNameList![i].id}'];

          if (bankPriceMap![widget.date.yyyymmdd] != null) {
            sum += bankPriceMap[widget.date.yyyymmdd]!;
          }
        }
      }

      list2.add(Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Text(sum.toString().toCurrency(), style: const TextStyle(color: Colors.yellowAccent)),
          ],
        ),
      ));

      for (var i = 0; i < _emoneyNameList!.length; i++) {
        list2.add(
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_emoneyNameList![i].emoneyName),
                Row(
                  children: [
                    Text(
                      _getListPrice(depositType: _emoneyNameList![i].depositType, id: _emoneyNameList![i].id)
                          .toString()
                          .toCurrency(),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => MoneyDialog(
                        context: context,
                        widget: BankPriceInputAlert(
                          date: widget.date,
                          isar: widget.isar,
                          depositType: DepositType.emoney,
                          emoneyName: _emoneyNameList![i],
                        ),
                      ),
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
  Future<void> _makeBankPriceList() async {
    await BankPricesRepository().getBankPriceList(isar: widget.isar).then((value) {
      setState(() {
        bankPriceList = value;

        if (value != null) {
          final bankPriceMap = makeBankPriceMap(bankPriceList: value);
          _bankPricePadMap = bankPriceMap['bankPriceDatePadMap'];
          _bankPriceTotalPadMap = bankPriceMap['bankPriceTotalPadMap'];
        }
      });
    });
  }

  ///
  int _getListPrice({required String depositType, required int id}) {
    var listPrice = 0;
    if (_bankPricePadMap['$depositType-$id'] != null) {
      final bankPriceMap = _bankPricePadMap['$depositType-$id'];
      if (bankPriceMap![widget.date.yyyymmdd] != null) {
        listPrice = bankPriceMap[widget.date.yyyymmdd]!;
      }
    }

    return listPrice;
  }

  ///
  Future<void> _makeSpendTimePlaceList() async {
    final param = <String, dynamic>{};
    param['date'] = widget.date.yyyymmdd;

    await SpendTimePlacesRepository()
        .getDateSpendTimePlaceList(isar: widget.isar, param: param)
        .then((value) => setState(() => _spendTimePlaceList = value));
  }

  ///
  Widget _displaySpendTimePlaceList() {
    final list = <Widget>[
      Column(
        children: [
          Container(
            width: context.screenSize.width,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.indigo.withOpacity(0.8), Colors.transparent], stops: const [0.7, 1]),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('SPEND', overflow: TextOverflow.ellipsis),
                GestureDetector(
                  onTap: () async {
                    if (_onedayMoneyTotal == 0) {
                      Future.delayed(
                        Duration.zero,
                        () => error_dialog(context: context, title: '登録できません。', content: '先にCURRENCYを入力してください。'),
                      );

                      return;
                    }

                    final oneday = widget.date.yyyymmdd;

                    final beforeDate = DateTime(
                        oneday.split('-')[0].toInt(), oneday.split('-')[1].toInt(), oneday.split('-')[2].toInt() - 1);

                    final onedayBankTotal = (_bankPriceTotalPadMap[oneday] != null) ? _bankPriceTotalPadMap[oneday] : 0;
                    final beforeBankTotal = (_bankPriceTotalPadMap[beforeDate.yyyymmdd] != null)
                        ? _bankPriceTotalPadMap[beforeDate.yyyymmdd]
                        : 0;

                    await ref.read(appParamProvider.notifier).setInputButtonClicked(flag: false);

                    if (mounted) {
                      await MoneyDialog(
                        context: context,
                        widget: SpendTimePlaceInputAlert(
                          date: widget.date,
                          spend: (_beforeMoneyTotal + beforeBankTotal!) - (_onedayMoneyTotal + onedayBankTotal!),
                          isar: widget.isar,
                          spendTimePlaceList: _spendTimePlaceList,
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

    if (_spendTimePlaceList!.isNotEmpty) {
      final spendItemColorMap = <String, String>{};
      if (_spendItemList!.isNotEmpty) {
        _spendItemList!.forEach((element) => spendItemColorMap[element.spendItemName] = element.color);
      }

      var sum = 0;
      makeMonthlySpendItemSumMap(spendItemList: _spendItemList, spendTimePlaceList: _spendTimePlaceList!)
          .forEach((key, value) => sum += value);

      list.add(Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Text(sum.toString().toCurrency(), style: const TextStyle(color: Colors.yellowAccent)),
          ],
        ),
      ));

      makeMonthlySpendItemSumMap(spendTimePlaceList: _spendTimePlaceList!, spendItemList: _spendItemList)
          .forEach((key, value) {
        final lineColor =
            (spendItemColorMap[key] != null && spendItemColorMap[key] != '') ? spendItemColorMap[key] : '0xffffffff';

        list.add(Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(child: Text(key, style: TextStyle(color: Color(lineColor!.toInt())))),
              Text(value.toString().toCurrency(), style: TextStyle(color: Color(lineColor.toInt()))),
            ],
          ),
        ));
      });
    }

    return Column(mainAxisSize: MainAxisSize.min, children: list);
  }

  ///
  Future<void> _makeIncomeMap() async {
    final param = <String, dynamic>{};
    final exDate = widget.date.yyyymmdd.split('-');
    param['year'] = exDate[0];
    param['month'] = exDate[1];

    await IncomesRepository().getYearMonthIncomeList(isar: widget.isar, param: param).then((value) {
      if (value!.isNotEmpty) {
        setState(() => value.forEach((element) => _incomeMap[element.date] = element));
      }
    });
  }

  ///
  Future<void> _makeSpendItemList() async {
    await SpendItemsRepository().getSpendItemList(isar: widget.isar).then((value) {
      if (mounted) {
        setState(() => _spendItemList = value);
      }
    });
  }
}
