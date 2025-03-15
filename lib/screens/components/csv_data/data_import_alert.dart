import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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

class DataImportAlert extends StatefulWidget {
  const DataImportAlert({super.key, required this.isar});

  final Isar isar;

  @override
  State<DataImportAlert> createState() => _DataImportAlertState();
}

class _DataImportAlertState extends State<DataImportAlert> {
  String fileName = '';

  String csvName = '';

  List<String> csvContentsList = <String>[];

  List<dynamic> importDataList = <dynamic>[];
  int importDataListLength = 0;

  ///
  @override
  void initState() {
    super.initState();

    fileName = '';

    csvName = '';

    csvContentsList = <String>[];

    importDataList = <dynamic>[];
  }

  ///
  Future<void> _pickAndLoadCsvFile() async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: <String>['csv']);

    if (result != null) {
      ///
      fileName = result.files.single.name;

      csvName = fileName.split('_')[0];

      ///
      final File file = File(result.files.single.path!);
      final String csvString = await file.readAsString();
      final List<String> exCsvString = csvString.split('\n');

      if (exCsvString[0] != 'export_csv_from_money_note') {
        setState(() {
          fileName = '';

          csvName = '';

          csvContentsList = <String>[];

          importDataList = <dynamic>[];
        });

        getErrorDialog(title: '出力できません。', content: '出力するデータを正しく選択してください。');

        return;
      }

      setState(() {
        csvContentsList = exCsvString;
      });
    }
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
              Container(width: context.screenSize.width),
              const SizedBox(height: 20),
              const Text('データインポート'),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _pickAndLoadCsvFile,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                      child: const Text('CSV選択'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: registData,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                      child: const Text('登録'),
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Text(fileName),
              if (csvContentsList.isNotEmpty) ...<Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const SizedBox.shrink(),
                    Text(
                      '${csvContentsList.length} records.',
                      style: const TextStyle(color: Colors.yellowAccent),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              Expanded(child: displayCsvContents()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget displayCsvContents() {
    switch (csvName) {
      case 'bankName':
        importDataList = <BankName>[];

      case 'bankPrice':
        importDataList = <BankPrice>[];

      case 'emoneyName':
        importDataList = <EmoneyName>[];

      case 'income':
        importDataList = <Income>[];

      case 'money':
        importDataList = <Money>[];

      case 'spendItem':
        importDataList = <SpendItem>[];

      case 'spendTimePlace':
        importDataList = <SpendTimePlace>[];
    }

    final List<Widget> widgetList = <Widget>[];

    for (int i = 1; i < csvContentsList.length; i++) {
      final List<String> exLine = csvContentsList[i].split(',');

      final List<Widget> widgetList2 = <Widget>[];

      for (int j = 1; j < exLine.length; j++) {
        widgetList2.add(
          Container(
            width: context.screenSize.width / 3,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Text(exLine[j], maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        );
      }

      widgetList.add(Row(children: widgetList2));

      switch (csvName) {
        case 'bankName':
          importDataList.add(BankName()
            ..bankNumber = exLine[1].trim()
            ..bankName = exLine[2].trim()
            ..branchNumber = exLine[3].trim()
            ..branchName = exLine[4].trim()
            ..accountType = exLine[5].trim()
            ..accountNumber = exLine[6].trim()
            ..depositType = exLine[7].trim());

        case 'bankPrice':
          importDataList.add(BankPrice()
            ..date = exLine[1].trim()
            ..depositType = exLine[2].trim()
            ..bankId = exLine[3].trim().toInt()
            ..price = exLine[4].trim().toInt());

        case 'emoneyName':
          importDataList.add(EmoneyName()
            ..emoneyName = exLine[1].trim()
            ..depositType = exLine[2].trim());

        case 'income':
          importDataList.add(Income()
            ..date = exLine[1].trim()
            ..sourceName = exLine[2].trim()
            ..price = exLine[3].trim().toInt());

        case 'money':
          importDataList.add(Money()
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
          importDataList.add(SpendItem()
            ..spendItemName = exLine[1].trim()
            ..order = exLine[2].trim().toInt()
            ..color = exLine[3].trim()
            ..defaultTime = exLine[4].trim());

        case 'spendTimePlace':
          importDataList.add(SpendTimePlace()
            ..date = exLine[1].trim()
            ..spendType = exLine[2].trim()
            ..time = exLine[3].trim()
            ..place = exLine[4].trim()
            ..price = exLine[5].trim().toInt());
      }
    }

    setState(() {
      importDataListLength = importDataList.length;
    });

    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgetList,
        ),
      ),
    );
  }

  ///
  void getErrorDialog({required String title, required String content}) {
    // ignore: always_specify_types
    Future.delayed(
      Duration.zero,
      () {
        if (mounted) {
          return error_dialog(context: context, title: title, content: content);
        }
      },
    );
  }

  ///
  Future<void> registData() async {
    if ((csvContentsList.length - 1) != importDataList.length) {
      getErrorDialog(title: '登録できません。', content: '登録するデータが正しく選択されていません。');

      return;
    }

    switch (csvName) {
      case 'bankName':
        await BankNamesRepository()
            .inputBankNameList(isar: widget.isar, bankNameList: importDataList as List<BankName>)
            // ignore: always_specify_types
            .then((value) {
          if (mounted) {
            Navigator.pop(context);
          }
        });

      case 'bankPrice':
        await BankPricesRepository()
            .inputBankPriceList(isar: widget.isar, bankPriceList: importDataList as List<BankPrice>)
            // ignore: always_specify_types
            .then((value) {
          if (mounted) {
            Navigator.pop(context);
          }
        });

      case 'emoneyName':
        await EmoneyNamesRepository()
            .inputEmoneyNameList(isar: widget.isar, emoneyNameList: importDataList as List<EmoneyName>)
            // ignore: always_specify_types
            .then((value) {
          if (mounted) {
            Navigator.pop(context);
          }
        });

      case 'income':
        await IncomesRepository()
            .inputIncomeList(isar: widget.isar, incomeList: importDataList as List<Income>)
            // ignore: always_specify_types
            .then((value) {
          if (mounted) {
            Navigator.pop(context);
          }
        });

      case 'money':
        await MoneysRepository()
            .inputMoneyList(isar: widget.isar, moneyList: importDataList as List<Money>)
            // ignore: always_specify_types
            .then((value) {
          if (mounted) {
            Navigator.pop(context);
          }
        });

      case 'spendItem':
        await SpendItemsRepository()
            .inputSpendItemList(isar: widget.isar, spendItemList: importDataList as List<SpendItem>)
            // ignore: always_specify_types
            .then((value) {
          if (mounted) {
            Navigator.pop(context);
          }
        });

      case 'spendTimePlace':
        await SpendTimePlacesRepository()
            .inputSpendTimePriceList(isar: widget.isar, spendTimePriceList: importDataList as List<SpendTimePlace>)
            // ignore: always_specify_types
            .then((value) {
          if (mounted) {
            Navigator.pop(context);
          }
        });
    }
  }
}
