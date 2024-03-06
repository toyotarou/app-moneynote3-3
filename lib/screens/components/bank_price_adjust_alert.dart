import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/bank_price.dart';
import '../../extensions/extensions.dart';
import '../../state/bank_price_adjust/bank_price_adjust_notifier.dart';
import 'parts/error_dialog.dart';

class Deposit {
  Deposit(this.flag, this.name);

  String flag;
  String name;
}

class BankPriceAdjustAlert extends ConsumerStatefulWidget {
  const BankPriceAdjustAlert({super.key, required this.isar, required this.depositNameList});

  final Isar isar;
  final List<Deposit> depositNameList;

  @override
  ConsumerState<BankPriceAdjustAlert> createState() => _BankPriceAdjustAlertState();
}

class _BankPriceAdjustAlertState extends ConsumerState<BankPriceAdjustAlert> {
  final List<TextEditingController> _bankPriceTecs = [];

  ///
  @override
  void initState() {
    super.initState();

    _makeTecs();
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
                children: [
                  const Text('金融機関、電子マネー金額修正'),
                  GestureDetector(
                    onTap: _inputBankPriceAdjust,
                    child: Icon(Icons.input, color: Colors.greenAccent.withOpacity(0.6), size: 16),
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

    for (var i = 0; i < 10; i++) {
      list.add(DecoratedBox(
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
                          items: widget.depositNameList.map((e) {
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
                              ref.read(bankPriceAdjustProvider.notifier).setAdjustPrice(pos: i, value: value.toInt());
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
          bankPriceAdjustState.adjustPrice[i] != 0) {
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

      if (bankPriceAdjustState.adjustPrice[i] != 0) {
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

      return;
    }

    //---------------------------//
    final bankPricesCollection = widget.isar.bankPrices;

    insertBankPriceList.forEach((element) async {
      final exElement = element.split('|');

      final getBankPrices = await bankPricesCollection
          .filter()
          .depositTypeEqualTo(exElement[0])
          .bankIdEqualTo(exElement[1].toInt())
          .dateEqualTo(exElement[2])
          .findAll();

      if (getBankPrices.isNotEmpty) {
        await widget.isar.writeTxn(
          () async {
            getBankPrices.forEach((element2) {
              bankPricesCollection.delete(element2.id);
            });
          },
        );
      }
    });

    //---------------------------//

    await widget.isar.writeTxn(() async {
      for (final bankPrice in list) {
        await widget.isar.bankPrices.put(bankPrice);
      }
    });

    await ref.read(bankPriceAdjustProvider.notifier).clearInputValue();

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
