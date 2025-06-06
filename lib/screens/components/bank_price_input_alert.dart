import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/bank_name.dart';
import '../../collections/bank_price.dart';
import '../../collections/emoney_name.dart';
import '../../controllers/controllers_mixin.dart';
import '../../enums/deposit_type.dart';
import '../../extensions/extensions.dart';
import '../../repository/bank_prices_repository.dart';

import '../../utilities/functions.dart';
import 'parts/error_dialog.dart';

// ignore: must_be_immutable
class BankPriceInputAlert extends ConsumerStatefulWidget {
  BankPriceInputAlert({
    super.key,
    required this.date,
    required this.isar,
    required this.depositType,
    this.bankName,
    this.emoneyName,
    required this.from,
  });

  final DateTime date;
  final Isar isar;
  final DepositType depositType;

  BankName? bankName;
  EmoneyName? emoneyName;

  final String from;

  @override
  ConsumerState<BankPriceInputAlert> createState() => _BankPriceInputAlertState();
}

class _BankPriceInputAlertState extends ConsumerState<BankPriceInputAlert> with ControllersMixin<BankPriceInputAlert> {
  List<BankPrice>? bankPriceList = <BankPrice>[];

  final TextEditingController _bankPriceEditingController = TextEditingController();

  late Color contextBlue;

  List<FocusNode> focusNodeList = <FocusNode>[];

  ///
  @override
  void initState() {
    super.initState();

    // ignore: always_specify_types
    focusNodeList = List.generate(100, (int index) => FocusNode());
  }

  ///
  @override
  void dispose() {
    _bankPriceEditingController.dispose();

    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    contextBlue = Theme.of(context).colorScheme.primary;

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
              Text(widget.date.yyyymmdd),
              if (widget.bankName != null) ...<Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.bankName!.bankName, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(widget.bankName!.branchName, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text('${widget.bankName!.accountType} ${widget.bankName!.accountNumber}'),
                  ],
                ),
              ],
              if (widget.emoneyName != null) ...<Widget>[
                Text(widget.emoneyName!.emoneyName, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              if (widget.from != 'BankPriceAdjustAlert') ...<Widget>[
                _displayInputParts(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox.shrink(),
                    TextButton(onPressed: _insertBankMoney, child: const Text('残高を入力する')),
                  ],
                ),
              ],
              displayBankYearSelector(),
              Row(
                children: <Widget>[
                  const SizedBox(width: 50),
                  Expanded(
                      child: Container(
                          alignment: Alignment.topRight,
                          child: const Text('minus', style: TextStyle(color: Colors.grey)))),
                  Expanded(
                      child: Container(
                          alignment: Alignment.topRight,
                          child: const Text('plus', style: TextStyle(color: Colors.grey)))),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<Widget>>(
                future: _displayBankPrices(),
                builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[Column(children: snapshot.data!), const SizedBox(height: 20)],
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget displayBankYearSelector() {
    final List<Widget> list = <Widget>[
      GestureDetector(
        onTap: () => appParamNotifier.setSelectedBankPriceYear(year: ''),
        child: Container(
          decoration:
              BoxDecoration(color: Colors.orangeAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: const Text('-'),
        ),
      ),
    ];

    final List<String> yearList = <String>[];

    bankPriceList?.forEach((BankPrice element) {
      if (!yearList.contains(element.date.split('-')[0])) {
        yearList.add(element.date.split('-')[0]);
      }
    });

    if (yearList.length == 1) {
      return const SizedBox.shrink();
    }

    for (final String element in yearList) {
      list.add(
        GestureDetector(
          onTap: () {
            appParamNotifier.setSelectedBankPriceYear(year: element);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orangeAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(element),
          ),
        ),
      );
    }

    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 10),
      width: context.screenSize.width,
      child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: list)),
    );
  }

  ///
  Widget _displayInputParts() {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[BoxShadow(blurRadius: 24, spreadRadius: 16, color: Colors.black.withOpacity(0.2))],
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
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _bankPriceEditingController,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                hintText: '金額(10桁以内)',
                filled: true,
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
              ),
              style: const TextStyle(fontSize: 13, color: Colors.white),
              onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
              focusNode: focusNodeList[0],
              onTap: () => context.showKeyboard(focusNodeList[0]),
            ),
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _insertBankMoney() async {
    final Id bankId = (widget.bankName != null) ? widget.bankName!.id : widget.emoneyName!.id;

    bool errFlg = false;

    if (_bankPriceEditingController.text.trim() == '' && bankId > 0) {
      errFlg = true;
    }

    if (!errFlg) {
      for (final List<Object> element in <List<Object>>[
        <Object>[_bankPriceEditingController.text.trim(), 10]
      ]) {
        if (!checkInputValueLengthCheck(value: element[0].toString().trim(), length: element[1] as int)) {
          errFlg = true;
        }
      }
    }

    if (errFlg) {
      // ignore: always_specify_types
      Future.delayed(
        Duration.zero,
        () => error_dialog(
            // ignore: use_build_context_synchronously
            context: context,
            title: '登録できません。',
            content: '値を正しく入力してください。'),
      );

      return;
    }

    //---------------------------//
    final IsarCollection<BankPrice> bankPricesCollection = BankPricesRepository().getCollection(isar: widget.isar);

    final List<BankPrice> getBankPrices = await bankPricesCollection
        .filter()
        .depositTypeEqualTo(widget.depositType.japanName)
        .bankIdEqualTo(bankId)
        .dateEqualTo(widget.date.yyyymmdd)
        .findAll();

    if (getBankPrices.isNotEmpty) {
      await BankPricesRepository().deleteBankPriceList(isar: widget.isar, bankPriceList: getBankPrices);
    }
    //---------------------------//

    final BankPrice bankPrice = BankPrice()
      ..date = widget.date.yyyymmdd
      ..depositType = widget.depositType.japanName
      ..bankId = bankId
      ..price = _bankPriceEditingController.text.trim().toInt();

    await BankPricesRepository()
        .inputBankPrice(isar: widget.isar, bankPrice: bankPrice)
        // ignore: always_specify_types
        .then((value) {
      _bankPriceEditingController.clear();

      if (mounted) {
        Navigator.pop(context);

        Navigator.pop(context);
      }
    });
  }

  ///
  Future<void> _makeBankPriceList() async {
    final Map<String, dynamic> param = <String, dynamic>{};
    param['depositType'] =
        (widget.bankName != null) ? widget.bankName!.depositType.trim() : widget.emoneyName!.depositType.trim();
    param['bankId'] = (widget.bankName != null) ? widget.bankName!.id : widget.emoneyName!.id;

    await BankPricesRepository()
        .getSelectedBankPriceList(isar: widget.isar, param: param)
        .then((List<BankPrice>? value) => setState(() => bankPriceList = value));
  }

  ///
  Future<List<Widget>> _displayBankPrices() async {
    await _makeBankPriceList();

    final List<Widget> list = <Widget>[];

    bankPriceList?.sort((BankPrice a, BankPrice b) => a.date.compareTo(b.date));

    int keepPrice = 0;

    for (int i = 0; i < bankPriceList!.length; i++) {
      final DateTime genDate = DateTime.parse('${bankPriceList![i].date} 00:00:00');
      final int diff = widget.date.difference(genDate).inDays;

      if (diff < 0) {
        continue;
      }

      final String year = bankPriceList![i].date.split('-')[0];
      if (appParamState.selectedBankPriceYear.isNotEmpty && year != appParamState.selectedBankPriceYear) {
        continue;
      }

      list.add(
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 50,
                child: Column(
                  children: <Widget>[
                    Text(bankPriceList![i].date.split('-')[0]),
                    Text('${bankPriceList![i].date.split('-')[1]}-${bankPriceList![i].date.split('-')[2]}')
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    displayRecordRow(data: bankPriceList!, index: i, beforePrice: keepPrice),
                    GestureDetector(
                      onTap: () => _showDeleteDialog(id: bankPriceList![i].id),
                      child: Text('delete', style: TextStyle(fontSize: 12, color: contextBlue)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

      keepPrice = bankPriceList![i].price;
    }

    return list;
  }

  ///
  Widget displayRecordRow({required List<BankPrice> data, required int index, required int beforePrice}) {
    final int diff = beforePrice - data[index].price;

    final String firstDate = data.first.date;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.2)))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: (data[index].date == firstDate)
                ? const Text('')
                : Container(
                    alignment: Alignment.topRight,
                    child: Text((diff < 0) ? '' : diff.toString().toCurrency()),
                  ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topRight,
              child: Text((diff < 0 && data[index].date != firstDate) ? (diff * -1).toString().toCurrency() : ''),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topRight,
              child: Text(data[index].price.toString().toCurrency()),
            ),
          ),
        ],
      ),
    );
  }

  ///
  void _showDeleteDialog({required int id}) {
    final Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text('いいえ'));

    final Widget continueButton = TextButton(
        onPressed: () {
          _deleteBankPrice(id: id);

          Navigator.pop(context);
        },
        child: const Text('はい'));

    final AlertDialog alert = AlertDialog(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      content: const Text('このデータを消去しますか？'),
      actions: <Widget>[cancelButton, continueButton],
    );

    // ignore: inference_failure_on_function_invocation
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  ///
  Future<void> _deleteBankPrice({required int id}) async =>
      BankPricesRepository().deleteBankPrice(isar: widget.isar, id: id);
}
