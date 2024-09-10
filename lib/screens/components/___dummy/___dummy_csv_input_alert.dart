import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../../collections/bank_name.dart';
import '../../../collections/bank_price.dart';
import '../../../collections/emoney_name.dart';
import '../../../collections/income.dart';
import '../../../collections/money.dart';
import '../../../collections/spend_item.dart';
import '../../../collections/spend_time_place.dart';
import '../../../extensions/extensions.dart';
import '../../../repository/bank_names_repository.dart';
import '../../../repository/bank_prices_repository.dart';
import '../../../repository/emoney_names_repository.dart';
import '../../../repository/incomes_repository.dart';
import '../../../repository/moneys_repository.dart';
import '../../../repository/spend_items_repository.dart';
import '../../../repository/spend_time_places_repository.dart';
import '../parts/error_dialog.dart';
import '___dummy_download_alert.dart';

class DummyCsvInputAlert extends ConsumerStatefulWidget {
  const DummyCsvInputAlert({super.key, required this.isar});

  final Isar isar;

  @override
  ConsumerState<DummyCsvInputAlert> createState() => _DummyCsvInputAlertState();
}

class _DummyCsvInputAlertState extends ConsumerState<DummyCsvInputAlert> {
  Map<String, int> recordNumMap = <String, int>{};

  ///
  @override
  void initState() {
    super.initState();

    for (final String element in <String>[
      'bankName',
      'bankPrice',
      'emoneyName',
      'income',
      'money',
      'spendItem',
      'spendTimePlace',
    ]) {
      switch (element) {
        case 'bankName':
          BankNamesRepository()
              .getBankNameList(isar: widget.isar)
              .then((List<BankName>? value) {
            setState(() {
              if (value != null) {
                recordNumMap[element] = value.length;
              }
            });
          });

        case 'bankPrice':
          BankPricesRepository()
              .getBankPriceList(isar: widget.isar)
              .then((List<BankPrice>? value) {
            setState(() {
              if (value != null) {
                recordNumMap[element] = value.length;
              }
            });
          });

        case 'emoneyName':
          EmoneyNamesRepository()
              .getEmoneyNameList(isar: widget.isar)
              .then((List<EmoneyName>? value) {
            setState(() {
              if (value != null) {
                recordNumMap[element] = value.length;
              }
            });
          });

        case 'income':
          IncomesRepository()
              .getIncomeList(isar: widget.isar)
              .then((List<Income>? value) {
            setState(() {
              if (value != null) {
                recordNumMap[element] = value.length;
              }
            });
          });

        case 'money':
          MoneysRepository()
              .getMoneyList(isar: widget.isar)
              .then((List<Money>? value) {
            setState(() {
              if (value != null) {
                recordNumMap[element] = value.length;
              }
            });
          });

        case 'spendItem':
          SpendItemsRepository()
              .getSpendItemList(isar: widget.isar)
              .then((List<SpendItem>? value) {
            setState(() {
              if (value != null) {
                recordNumMap[element] = value.length;
              }
            });
          });

        case 'spendTimePlace':
          SpendTimePlacesRepository()
              .getSpendTimePlaceList(isar: widget.isar)
              .then((List<SpendTimePlace>? value) {
            setState(() {
              if (value != null) {
                recordNumMap[element] = value.length;
              }
            });
          });
      }
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    final String csvName = ref.watch(dummyDownloadProvider
        .select((DummyDownloadState value) => value.csvName));

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
                Text(csvName),
                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <String>[
                    'bankName',
                    'bankPrice',
                    'emoneyName',
                    'income',
                    'money',
                    'spendItem',
                    'spendTimePlace',
                  ].map((String e) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(dummyDownloadProvider.notifier)
                                    .setCsvName(csvName: e);
                              },
                              child: Text(e),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                        Text(
                          '${recordNumMap[e] ?? 0}',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                ElevatedButton(
                  onPressed: () => csvInput(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                  child: const Text('csv input'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final List<String> csvFiles = <String>[
    'bankName_20240910152417.csv',
    'bankPrice_20240910152420.csv',
    'emoneyName_20240910152424.csv',
    'income_20240910152428.csv',
    'money_20240910152432.csv',
    'spendItem_20240910152435.csv',
    'spendTimePlace_20240910152438.csv',
  ];

  ///
  Future<void> csvInput() async {
    final String csvName = ref.watch(dummyDownloadProvider
        .select((DummyDownloadState value) => value.csvName));

    if (csvName == '') {
      getErrorDialog(title: '出力できません。', content: '出力するデータを正しく選択してください。');

      return;
    }

    final RegExp reg = RegExp(csvName);

    String file = '';

    for (final String element in csvFiles) {
      if (reg.firstMatch(element) != null) {
        file = element;
      }
    }

    final String path = 'assets/csv/$file';

    final String csv = await rootBundle.loadString(path);

    final List<String> exCsv = csv.split('\n');

    List<dynamic> list = <dynamic>[];

    switch (csvName) {
      case 'bankName':
        list = <BankName>[];

      case 'bankPrice':
        list = <BankPrice>[];

      case 'emoneyName':
        list = <EmoneyName>[];

      case 'income':
        list = <Income>[];

      case 'money':
        list = <Money>[];

      case 'spendItem':
        list = <SpendItem>[];

      case 'spendTimePlace':
        list = <SpendTimePlace>[];
    }

    for (int i = 0; i < exCsv.length; i++) {
      final List<String> exLine = exCsv[i].split(',');

      switch (csvName) {
        case 'bankName':
          list.add(BankName()
            ..bankNumber = exLine[1].trim()
            ..bankName = exLine[2].trim()
            ..branchNumber = exLine[3].trim()
            ..branchName = exLine[4].trim()
            ..accountType = exLine[5].trim()
            ..accountNumber = exLine[6].trim()
            ..depositType = exLine[7].trim());

        case 'bankPrice':
          list.add(BankPrice()
            ..date = exLine[1].trim()
            ..depositType = exLine[2].trim()
            ..bankId = exLine[3].trim().toInt()
            ..price = exLine[4].trim().toInt());

        case 'emoneyName':
          list.add(EmoneyName()
            ..emoneyName = exLine[1].trim()
            ..depositType = exLine[2].trim());

        case 'income':
          list.add(Income()
            ..date = exLine[1].trim()
            ..sourceName = exLine[2].trim()
            ..price = exLine[3].trim().toInt());

        case 'money':
          list.add(Money()
            ..date = exLine[1].trim()
            ..yen_10000 = exLine[2].trim().toInt()
            ..yen_5000 = exLine[3].trim().toInt()
            ..yen_2000 = exLine[4].trim().toInt()
            ..yen_1000 = exLine[5].trim().toInt()
            ..yen_500 = exLine[6].trim().toInt()
            ..yen_100 = exLine[7].trim().toInt()
            ..yen_50 = exLine[8].trim().toInt()
            ..yen_10 = exLine[9].trim().toInt()
            ..yen_5 = exLine[10].trim().toInt()
            ..yen_1 = exLine[11].trim().toInt());

        case 'spendItem':
          list.add(SpendItem()
            ..spendItemName = exLine[1].trim()
            ..order = exLine[2].trim().toInt()
            ..color = exLine[3].trim()
            ..defaultTime = exLine[4].trim());

        case 'spendTimePlace':
          list.add(SpendTimePlace()
            ..date = exLine[1].trim()
            ..spendType = exLine[2].trim()
            ..time = exLine[3].trim()
            ..place = exLine[4].trim()
            ..price = exLine[5].trim().toInt());
      }
    }

    switch (csvName) {
      case 'bankName':
        await BankNamesRepository()
            .inputBankNameList(
                isar: widget.isar, bankNameList: list as List<BankName>)
            // ignore: always_specify_types
            .then((value) {
          Navigator.pop(context);
        });

      case 'bankPrice':
        await BankPricesRepository()
            .inputBankPriceList(
                isar: widget.isar, bankPriceList: list as List<BankPrice>)
            // ignore: always_specify_types
            .then((value) {
          Navigator.pop(context);
        });

      case 'emoneyName':
        await EmoneyNamesRepository()
            .inputEmoneyNameList(
                isar: widget.isar, emoneyNameList: list as List<EmoneyName>)
            // ignore: always_specify_types
            .then((value) {
          Navigator.pop(context);
        });

      case 'income':
        await IncomesRepository()
            .inputIncomeList(
                isar: widget.isar, incomeList: list as List<Income>)
            // ignore: always_specify_types
            .then((value) {
          Navigator.pop(context);
        });

      case 'money':
        await MoneysRepository()
            .inputMoneyList(isar: widget.isar, moneyList: list as List<Money>)
            // ignore: always_specify_types
            .then((value) {
          Navigator.pop(context);
        });

      case 'spendItem':
        await SpendItemsRepository()
            .inputSpendItemList(
                isar: widget.isar, spendItemList: list as List<SpendItem>)
            // ignore: always_specify_types
            .then((value) {
          Navigator.pop(context);
        });

      case 'spendTimePlace':
        await SpendTimePlacesRepository()
            .inputSpendTimePriceList(
                isar: widget.isar,
                spendTimePriceList: list as List<SpendTimePlace>)
            // ignore: always_specify_types
            .then((value) {
          Navigator.pop(context);
        });
    }
  }

  ///
  void getErrorDialog({required String title, required String content}) {
    // ignore: always_specify_types
    Future.delayed(
      Duration.zero,
      () => error_dialog(context: context, title: title, content: content),
    );
  }
}
