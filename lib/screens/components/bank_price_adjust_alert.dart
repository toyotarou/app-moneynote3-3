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

class _BankPriceAdjustAlertState extends ConsumerState<BankPriceAdjustAlert>
    with ControllersMixin<BankPriceAdjustAlert> {
  final List<TextEditingController> _bankPriceTecs = <TextEditingController>[];

  Map<int, BankName> bankNameMap = <int, BankName>{};
  Map<int, EmoneyName> emoneyNameMap = <int, EmoneyName>{};

  List<FocusNode> focusNodeList = <FocusNode>[];

  ///
  @override
  void initState() {
    super.initState();

    _makeTecs();

    // ignore: always_specify_types
    focusNodeList = List.generate(100, (int index) => FocusNode());
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DefaultTextStyle(
          style: GoogleFonts.kiwiMaru(fontSize: 12),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('金融機関、電子マネー金額修正'),
                  ElevatedButton(
                    onPressed: appParamState.inputButtonClicked
                        ? null
                        : () {
                            appParamNotifier.setInputButtonClicked(flag: true);

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
    for (int i = 0; i < 10; i++) {
      _bankPriceTecs.add(TextEditingController(text: ''));
    }
  }

  ///
  Widget _displayInputParts() {
    final List<Widget> list = <Widget>[];

    final List<DepoItem> depoItemList = <DepoItem>[];

    final List<Deposit> depositNameList = <Deposit>[Deposit('', '')];

    widget.bankNameList?.forEach((BankName element) {
      depositNameList.add(
        Deposit('${element.depositType}-${element.id}', '${element.bankName} ${element.branchName}'),
      );

      depoItemList.add(DepoItem(element.id, '${element.bankName}\n${element.branchName}', DepositType.bank));

      bankNameMap[element.id] = element;
    });

    widget.emoneyNameList?.forEach((EmoneyName element) {
      depositNameList.add(Deposit('${element.depositType}-${element.id}', element.emoneyName));

      depoItemList.add(DepoItem(element.id, element.emoneyName, DepositType.emoney));

      emoneyNameMap[element.id] = element;
    });

    //==============================================
    list.add(const SizedBox(height: 10));

    final List<Widget> list2 = <Widget>[];
    for (final DepoItem element in depoItemList) {
      list2.add(
        Row(
          children: <Widget>[
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
                      from: 'BankPriceAdjustAlert',
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
                      from: 'BankPriceAdjustAlert',
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
    }

    list
      ..add(SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: list2)))
      ..add(const SizedBox(height: 10));
    //==============================================

    for (int i = 0; i < 10; i++) {
      list.add(DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[BoxShadow(blurRadius: 24, spreadRadius: 16, color: Colors.black.withOpacity(0.2))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Stack(
              children: <Widget>[
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
                    children: <Widget>[
                      Row(
                        children: <Widget>[
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
                            // ignore: always_specify_types
                            child: DropdownButton(
                              isExpanded: true,
                              dropdownColor: Colors.pinkAccent.withOpacity(0.1),
                              iconEnabledColor: Colors.white,
                              items: depositNameList.map((Deposit e) {
                                // ignore: always_specify_types
                                return DropdownMenuItem(
                                  value: e.flag,
                                  child: Text(e.name, style: const TextStyle(fontSize: 12)),
                                );
                              }).toList(),
                              value: bankPriceAdjustState.adjustDeposit[i],
                              onChanged: (String? value) {
                                bankPriceAdjustNotifier.setAdjustDeposit(pos: i, value: value!);
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _bankPriceTecs[i],
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
                              onChanged: (String value) {
                                if (value != '') {
                                  bankPriceAdjustNotifier.setAdjustPrice(pos: i, value: value.trim().toInt());
                                }
                              },
                              focusNode: focusNodeList[i],
                              onTap: () => context.showKeyboard(focusNodeList[i]),
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

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => list[index],
            childCount: list.length,
          ),
        ),
      ],
    );
  }

  ///
  Future<void> _showDP({required int pos}) async {
    final DateTime? selectedDate = await showDatePicker(
      barrierColor: Colors.transparent,
      locale: const Locale('ja'),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 360)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black.withOpacity(0.1),
            canvasColor: Colors.black.withOpacity(0.1),
            cardColor: Colors.black.withOpacity(0.1),
            dividerColor: Colors.indigo,
            primaryColor: Colors.black.withOpacity(0.1),
            secondaryHeaderColor: Colors.black.withOpacity(0.1),
            dialogBackgroundColor: Colors.black.withOpacity(0.1),
            primaryColorDark: Colors.black.withOpacity(0.1),
            highlightColor: Colors.black.withOpacity(0.1),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      await bankPriceAdjustNotifier.setAdjustDate(pos: pos, value: selectedDate.yyyymmdd);
    }
  }

  ///
  Future<void> _inputBankPriceAdjust() async {
    final List<BankPrice> list = <BankPrice>[];

    bool errFlg = false;

    ////////////////////////// 同数チェック
    int adjustDateCount = 0;
    int adjustDepositCount = 0;
    int adjustPriceCount = 0;
    ////////////////////////// 同数チェック

    final List<String> insertBankPriceList = <String>[];

    for (int i = 0; i < 10; i++) {
      //===============================================
      if (bankPriceAdjustState.adjustDate[i] != '日付' &&
          bankPriceAdjustState.adjustDeposit[i] != '' &&
          bankPriceAdjustState.adjustPrice[i] >= 0) {
        final List<String> exDeposit = bankPriceAdjustState.adjustDeposit[i].split('-');

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
    final Map<int, String> countCheck = <int, String>{};
    countCheck[adjustDateCount] = '';
    countCheck[adjustDepositCount] = '';
    countCheck[adjustPriceCount] = '';

    // 同数の場合、要素数は1になる
    if (countCheck.length > 1) {
      errFlg = true;
    }
    ////////////////////////// 同数チェック

    if (!errFlg) {
      for (final BankPrice element in list) {
        for (final List<int> element2 in <List<int>>[
          <int>[element.price, 10]
        ]) {
          if (!checkInputValueLengthCheck(value: element2[0].toString().trim(), length: element2[1])) {
            errFlg = true;
          }
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

      appParamNotifier.setInputButtonClicked(flag: false);

      return;
    }

    //---------------------------//
    final IsarCollection<BankPrice> bankPricesCollection = BankPricesRepository().getCollection(isar: widget.isar);

    // ignore: avoid_function_literals_in_foreach_calls
    insertBankPriceList.forEach((String element) async {
      final List<String> exElement = element.split('|');

      final List<BankPrice> getBankPrices = await bankPricesCollection
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

    await BankPricesRepository()
        .inputBankPriceList(isar: widget.isar, bankPriceList: list)
        // ignore: always_specify_types
        .then((value) async => bankPriceAdjustNotifier
                .clearInputValue()
                // ignore: always_specify_types
                .then((value) {
              if (mounted) {
                Navigator.pop(context);
              }
            }));
  }
}

///
class DepoItem {
  DepoItem(this.id, this.name, this.type);

  int id;
  String name;
  DepositType type;
}
