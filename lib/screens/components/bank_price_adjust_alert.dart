import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/bank_name.dart';
import '../../collections/bank_price.dart';
import '../../collections/emoney_name.dart';
import '../../enums/deposit_type.dart';
import '../../extensions/extensions.dart';
import '../../repository/bank_prices_repository.dart';
import '../../state/app_params/app_params_notifier.dart';
import '../../state/bank_price_adjust/bank_price_adjust_notifier.dart';
import 'bank_price_input_alert.dart';
import 'parts/error_dialog.dart';
import 'parts/money_dialog.dart';

class Deposit {
  Deposit(this.flag, this.name);

  String flag;
  String name;
}

class BankPriceAdjustAlert extends ConsumerStatefulWidget {
  const BankPriceAdjustAlert({super.key, required this.isar, this.bankNameList, this.emoneyNameList});

  final Isar isar;

  final List<BankName>? bankNameList;

  final List<EmoneyName>? emoneyNameList;

  @override
  ConsumerState<BankPriceAdjustAlert> createState() => _BankPriceAdjustAlertState();
}

class _BankPriceAdjustAlertState extends ConsumerState<BankPriceAdjustAlert> {
  final List<TextEditingController> _bankPriceTecs = [];

  Map<int, BankName> bankNameMap = {};
  Map<int, EmoneyName> emoneyNameMap = {};

  ///
  @override
  void initState() {
    super.initState();

    _makeTecs();
  }

  ///
  @override
  Widget build(BuildContext context) {
    final inputButtonClicked = ref.watch(appParamProvider.select((value) => value.inputButtonClicked));

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
                children: [
                  const Text('金融機関、電子マネー金額修正'),
                  ElevatedButton(
                    onPressed: inputButtonClicked
                        ? null
                        : () {
                            ref.read(appParamProvider.notifier).setInputButtonClicked(flag: true);

                            _inputBankPriceAdjust();
                          },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                    child: const Text('input'),
                  ),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(child: _displayInputParts()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void _makeTecs() {
    for (var i = 0; i < 10; i++) {
      _bankPriceTecs.add(TextEditingController(text: ''));
    }
  }

  ///
  Widget _displayInputParts() {
    final bankPriceAdjustState = ref.watch(bankPriceAdjustProvider);

    final list = <Widget>[];

    final depoItemList = <DepoItem>[];

    final depositNameList = <Deposit>[Deposit('', '')];

    widget.bankNameList?.forEach((element) {
      depositNameList.add(
        Deposit('${element.depositType}-${element.id}', '${element.bankName} ${element.branchName}'),
      );

      depoItemList.add(DepoItem(element.id, '${element.bankName}\n${element.branchName}', DepositType.bank));

      bankNameMap[element.id] = element;
    });

    widget.emoneyNameList?.forEach((element) {
      depositNameList.add(Deposit('${element.depositType}-${element.id}', element.emoneyName));

      depoItemList.add(DepoItem(element.id, element.emoneyName, DepositType.emoney));

      emoneyNameMap[element.id] = element;
    });

    //==============================================
    list.add(const SizedBox(height: 10));

    final list2 = <Widget>[];
    depoItemList.forEach((element) {
      list2.add(
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (element.type == DepositType.bank) {
                  MoneyDialog(
                    context: context,
                    widget: BankPriceInputAlert(
                      date: DateTime.now(),
                      isar: widget.isar,
                      depositType: DepositType.bank,
                      bankName: bankNameMap[element.id],
                    ),
                  );
                }
                if (element.type == DepositType.emoney) {
                  MoneyDialog(
                    context: context,
                    widget: BankPriceInputAlert(
                      date: DateTime.now(),
                      isar: widget.isar,
                      depositType: DepositType.emoney,
                      emoneyName: emoneyNameMap[element.id],
                    ),
                  );
                }
              },
              child: CircleAvatar(
                backgroundColor: (element.type == DepositType.bank)
                    ? Colors.blueAccent.withOpacity(0.2)
                    : Colors.greenAccent.withOpacity(0.2),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    element.name,
                    style: const TextStyle(fontSize: 8, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
          ],
        ),
      );
    });

    list
      ..add(SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: list2)))
      ..add(const SizedBox(height: 10));
    //==============================================

    for (var i = 0; i < 10; i++) {
      list.add(DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 24, spreadRadius: 16, color: Colors.black.withOpacity(0.2))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Stack(
              children: [
                Positioned(
                  bottom: 5,
                  right: 15,
                  child: Text(
                    (i + 1).toString().padLeft(2, '0'),
                    style: TextStyle(fontSize: 60, color: Colors.grey.withOpacity(0.3)),
                  ),
                ),
                Container(
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
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _showDP(pos: i),
                            child: Icon(Icons.calendar_month, color: Colors.greenAccent.withOpacity(0.6)),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: context.screenSize.width / 6,
                            child: Text(bankPriceAdjustState.adjustDate[i], style: const TextStyle(fontSize: 10)),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: DropdownButton(
                              isExpanded: true,
                              dropdownColor: Colors.pinkAccent.withOpacity(0.1),
                              iconEnabledColor: Colors.white,
                              items: depositNameList.map((e) {
                                return DropdownMenuItem(
                                  value: e.flag,
                                  child: Text(e.name, style: const TextStyle(fontSize: 12)),
                                );
                              }).toList(),
                              value: bankPriceAdjustState.adjustDeposit[i],
                              onChanged: (value) {
                                ref.read(bankPriceAdjustProvider.notifier).setAdjustDeposit(pos: i, value: value!);
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _bankPriceTecs[i],
                              decoration: const InputDecoration(labelText: '金額'),
                              style: const TextStyle(fontSize: 13, color: Colors.white),
                              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                              onChanged: (value) {
                                if (value != '') {
                                  ref
                                      .read(bankPriceAdjustProvider.notifier)
                                      .setAdjustPrice(pos: i, value: value.toInt());
                                }
                              },
                            ),
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
      ));
    }

    return SingleChildScrollView(child: Column(children: list));
  }

  ///
  Future<void> _showDP({required int pos}) async {
    final selectedDate = await showDatePicker(
      barrierColor: Colors.transparent,
      locale: const Locale('ja'),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 360)),
    );

    if (selectedDate != null) {
      await ref.read(bankPriceAdjustProvider.notifier).setAdjustDate(pos: pos, value: selectedDate.yyyymmdd);
    }
  }

  ///
  Future<void> _inputBankPriceAdjust() async {
    final bankPriceAdjustState = ref.watch(bankPriceAdjustProvider);

    final list = <BankPrice>[];

    var errFlg = false;

    ////////////////////////// 同数チェック
    var adjustDateCount = 0;
    var adjustDepositCount = 0;
    var adjustPriceCount = 0;
    ////////////////////////// 同数チェック

    final insertBankPriceList = <String>[];

    for (var i = 0; i < 10; i++) {
      //===============================================
      if (bankPriceAdjustState.adjustDate[i] != '日付' &&
          bankPriceAdjustState.adjustDeposit[i] != '' &&
          bankPriceAdjustState.adjustPrice[i] >= 0) {
        final exDeposit = bankPriceAdjustState.adjustDeposit[i].split('-');

        list.add(
          BankPrice()
            ..date = bankPriceAdjustState.adjustDate[i]
            ..depositType = exDeposit[0]
            ..bankId = exDeposit[1].toInt()
            ..price = bankPriceAdjustState.adjustPrice[i],
        );

        insertBankPriceList.add('${exDeposit[0]}|${exDeposit[1]}|${bankPriceAdjustState.adjustDate[i]}');
      }
      //===============================================

      if (bankPriceAdjustState.adjustDate[i] != '日付') {
        adjustDateCount++;
      }

      if (bankPriceAdjustState.adjustDeposit[i] != '') {
        adjustDepositCount++;
      }

      if (bankPriceAdjustState.adjustPrice[i] >= 0) {
        adjustPriceCount++;
      }
    }

    if (list.isEmpty) {
      errFlg = true;
    }

    ////////////////////////// 同数チェック
    final countCheck = <int, String>{};
    countCheck[adjustDateCount] = '';
    countCheck[adjustDepositCount] = '';
    countCheck[adjustPriceCount] = '';

    // 同数の場合、要素数は1になる
    if (countCheck.length > 1) {
      errFlg = true;
    }
    ////////////////////////// 同数チェック

    if (errFlg) {
      Future.delayed(
        Duration.zero,
        () => error_dialog(context: context, title: '登録できません。', content: '値を正しく入力してください。'),
      );

      await ref.read(appParamProvider.notifier).setInputButtonClicked(flag: false);

      return;
    }

    //---------------------------//
    final bankPricesCollection = BankPricesRepository().getCollection(isar: widget.isar);

    insertBankPriceList.forEach((element) async {
      final exElement = element.split('|');

      final getBankPrices = await bankPricesCollection
          .filter()
          .depositTypeEqualTo(exElement[0])
          .bankIdEqualTo(exElement[1].toInt())
          .dateEqualTo(exElement[2])
          .findAll();

      if (getBankPrices.isNotEmpty) {
        await BankPricesRepository().deleteBankPriceList(isar: widget.isar, bankPriceList: getBankPrices);
      }
    });

    //---------------------------//

    await BankPricesRepository().inputBankPriceList(isar: widget.isar, bankPriceList: list).then((value) async {
      await ref.read(bankPriceAdjustProvider.notifier).clearInputValue().then((value) => Navigator.pop(context));
    });
  }
}

///
class DepoItem {
  DepoItem(this.id, this.name, this.type);

  int id;
  String name;
  DepositType type;
}
