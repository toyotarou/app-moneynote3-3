import 'dart:io';

import 'package:charset_converter/charset_converter.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

import '../../collections/bank_name.dart';
import '../../collections/emoney_name.dart';
import '../../collections/money.dart';
import '../../collections/spend_time_place.dart';
import '../../enums/data_download_data_type.dart';
import '../../enums/data_download_date_type.dart';
import '../../extensions/extensions.dart';
import '../../state/data_download/data_download_notifier.dart';
import 'parts/error_dialog.dart';

class DownloadDataListAlert extends ConsumerStatefulWidget {
  const DownloadDataListAlert({
    super.key,
    required this.isar,
    required this.moneyMap,
    required this.allSpendTimePlaceList,
    required this.bankNameList,
    required this.emoneyNameList,
    required this.bankPricePadMap,
  });

  final Isar isar;
  final Map<String, Money> moneyMap;
  final List<SpendTimePlace> allSpendTimePlaceList;
  final List<BankName> bankNameList;
  final List<EmoneyName> emoneyNameList;
  final Map<String, Map<String, int>> bankPricePadMap;

  ///
  @override
  ConsumerState<DownloadDataListAlert> createState() => _DownloadDataListAlertState();
}

class _DownloadDataListAlertState extends ConsumerState<DownloadDataListAlert> {
  Map<String, List<SpendTimePlace>> spendTimePlaceMap = {};

  List<String> outputValuesList = [];

  String externalStoragePublicDirectoryPath = '';

  ///
  @override
  void initState() {
    super.initState();

    widget.allSpendTimePlaceList.forEach((element) => spendTimePlaceMap[element.date] = []);
    widget.allSpendTimePlaceList.forEach((element) => spendTimePlaceMap[element.date]?.add(element));

    getPublicDirectoryPath();
  }

  ///
  Future<void> getPublicDirectoryPath() async {
    final path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    setState(() {
      externalStoragePublicDirectoryPath = path;
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    final dataDownloadState = ref.watch(dataDownloadProvider);

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
                children: [const Text('ダウンロードデータ選択'), Container()],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Row(
                children: [
                  SizedBox(
                    width: context.screenSize.width * 0.3,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            ref.read(dataDownloadProvider.notifier).setDataType(dataType: DateDownloadDataType.none);

                            _showDP(pos: DateDownloadDateType.start);
                          },
                          icon: Icon(Icons.calendar_month, color: Colors.greenAccent.withOpacity(0.6)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [const Text('Start'), Text(dataDownloadState.startDate)],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Text('〜'),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          ref.read(dataDownloadProvider.notifier).setDataType(dataType: DateDownloadDataType.none);

                          _showDP(pos: DateDownloadDateType.end);
                        },
                        icon: Icon(Icons.calendar_month, color: Colors.greenAccent.withOpacity(0.6)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [const Text('End'), Text(dataDownloadState.endDate)],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: (dataDownloadState.dataType == DateDownloadDataType.money)
                            ? Colors.yellowAccent.withOpacity(0.3)
                            : Colors.pinkAccent.withOpacity(0.2)),
                    onPressed: () {
                      if (dataDownloadState.startDate == '' || dataDownloadState.endDate == '') {
                        getErrorDialog(title: '選択できません。', content: '日付を正しく入力してください。');
                        return;
                      }

                      ref.read(dataDownloadProvider.notifier).setDataType(dataType: DateDownloadDataType.money);
                    },
                    child: const Text('money', style: TextStyle(fontSize: 10)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: (dataDownloadState.dataType == DateDownloadDataType.bank)
                            ? Colors.yellowAccent.withOpacity(0.3)
                            : Colors.pinkAccent.withOpacity(0.2)),
                    onPressed: () {
                      if (dataDownloadState.startDate == '' || dataDownloadState.endDate == '') {
                        getErrorDialog(title: '選択できません。', content: '日付を正しく入力してください。');
                        return;
                      }

                      ref.read(dataDownloadProvider.notifier).setDataType(dataType: DateDownloadDataType.bank);
                    },
                    child: const Text('bank', style: TextStyle(fontSize: 10)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: (dataDownloadState.dataType == DateDownloadDataType.spend)
                            ? Colors.yellowAccent.withOpacity(0.3)
                            : Colors.pinkAccent.withOpacity(0.2)),
                    onPressed: () {
                      if (dataDownloadState.startDate == '' || dataDownloadState.endDate == '') {
                        getErrorDialog(title: '選択できません。', content: '日付を正しく入力してください。');
                        return;
                      }

                      ref.read(dataDownloadProvider.notifier).setDataType(dataType: DateDownloadDataType.spend);
                    },
                    child: const Text('spend', style: TextStyle(fontSize: 10)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  TextButton(
                    onPressed: outputCsv,
                    child: const Text('CSVを出力する'),
                  ),
                ],
              ),
              Expanded(child: _displayDownloadData()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void getErrorDialog({required String title, required String content}) {
    Future.delayed(
      Duration.zero,
      () => error_dialog(context: context, title: title, content: content),
    );
  }

  ///
  Future<void> _showDP({required DateDownloadDateType pos}) async {
    final selectedDate = await showDatePicker(
      barrierColor: Colors.transparent,
      locale: const Locale('ja'),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 360)),
    );

    if (selectedDate != null) {
      switch (pos) {
        case DateDownloadDateType.start:
          await ref.read(dataDownloadProvider.notifier).setStartDate(date: selectedDate.yyyymmdd);
          break;
        case DateDownloadDateType.end:
          await ref.read(dataDownloadProvider.notifier).setEndDate(date: selectedDate.yyyymmdd);
          break;
      }
    }
  }

  ///
  Widget _displayDownloadData() {
    final list = <Widget>[];

    final dataDownloadState = ref.watch(dataDownloadProvider);

    if (dataDownloadState.dataType != null) {
      //=====================//
      final dateList = <String>[];

      if (dataDownloadState.endDate != '' && dataDownloadState.startDate != '') {
        final dateDiff =
            DateTime.parse('${dataDownloadState.endDate} 00:00:00').difference(DateTime.parse('${dataDownloadState.startDate} 00:00:00')).inDays;

        for (var i = 0; i <= dateDiff; i++) {
          final day = DateTime.parse('${dataDownloadState.startDate} 00:00:00').add(Duration(days: i));

          dateList.add(day.yyyymmdd);
        }
      }
      //=====================//

      switch (dataDownloadState.dataType!) {
        case DateDownloadDataType.none:
          break;

        case DateDownloadDataType.money:
          outputValuesList = [];

          widget.moneyMap.forEach((key, value) {
            if (dateList.contains(key)) {
              list.add(Row(
                children: [
                  getDataCell(data: value.date, width: 100, alignment: Alignment.topLeft),
                  getDataCell(data: value.yen_10000.toString().toCurrency(), width: 50, alignment: Alignment.topRight),
                  getDataCell(data: value.yen_5000.toString().toCurrency(), width: 50, alignment: Alignment.topRight),
                  getDataCell(data: value.yen_2000.toString().toCurrency(), width: 50, alignment: Alignment.topRight),
                  getDataCell(data: value.yen_1000.toString().toCurrency(), width: 50, alignment: Alignment.topRight),
                  getDataCell(data: value.yen_500.toString().toCurrency(), width: 50, alignment: Alignment.topRight),
                  getDataCell(data: value.yen_100.toString().toCurrency(), width: 50, alignment: Alignment.topRight),
                  getDataCell(data: value.yen_50.toString().toCurrency(), width: 50, alignment: Alignment.topRight),
                  getDataCell(data: value.yen_10.toString().toCurrency(), width: 50, alignment: Alignment.topRight),
                  getDataCell(data: value.yen_5.toString().toCurrency(), width: 50, alignment: Alignment.topRight),
                  getDataCell(data: value.yen_1.toString().toCurrency(), width: 50, alignment: Alignment.topRight),
                ],
              ));

              outputValuesList.add([
                value.date,
                value.yen_10000.toString(),
                value.yen_5000.toString(),
                value.yen_2000.toString(),
                value.yen_1000.toString(),
                value.yen_500.toString(),
                value.yen_100.toString(),
                value.yen_50.toString(),
                value.yen_10.toString(),
                value.yen_5.toString(),
                value.yen_1.toString(),
              ].join(','));
            }
          });
          break;

        case DateDownloadDataType.bank:
          outputValuesList = [];

          dateList.forEach((element) {
            list.add(
              Row(children: [
                getDataCell(data: element, width: 100, alignment: Alignment.topLeft),
                Row(children: widget.bankNameList.map((e) => _displayBankPriceListData(date: element, bankName: e)).toList()),
                Row(children: widget.emoneyNameList.map((e) => _displayBankPriceListData(date: element, emoneyName: e)).toList())
              ]),
            );

            final outVal = <String>[element];
            widget.bankNameList
                .forEach((element2) => outVal.add(_getBankPriceData(deposit: '${element2.depositType}-${element2.id}', date: element).toString()));
            widget.emoneyNameList
                .forEach((element2) => outVal.add(_getBankPriceData(deposit: '${element2.depositType}-${element2.id}', date: element).toString()));

            outputValuesList.add(outVal.join(','));
          });
          break;

        case DateDownloadDataType.spend:
          outputValuesList = [];

          spendTimePlaceMap.forEach((key, value) {
            if (dateList.contains(key)) {
              value.forEach((element) {
                list.add(Row(
                  children: [
                    getDataCell(data: element.date, width: 100, alignment: Alignment.topLeft),
                    getDataCell(data: element.time, width: 60, alignment: Alignment.topLeft),
                    getDataCell(data: element.spendType, width: 120, alignment: Alignment.topLeft),
                    getDataCell(data: element.price.toString().toCurrency(), width: 80, alignment: Alignment.topRight),
                    getDataCell(data: element.place, width: 200, alignment: Alignment.topLeft),
                  ],
                ));

                outputValuesList.add([element.date, element.time, element.spendType, element.price.toString(), element.place].join(','));
              });
            }
          });
          break;
      }
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(physics: const BouncingScrollPhysics(), child: Column(children: list)),
    );
  }

  ///
  int _getBankPriceData({required String deposit, required String date}) {
    var dispPrice = 0;
    if (widget.bankPricePadMap[deposit] != null) {
      if (widget.bankPricePadMap[deposit]![date] != null) {
        dispPrice = widget.bankPricePadMap[deposit]![date]!;
      }
    }

    return dispPrice;
  }

  ///
  Widget _displayBankPriceListData({required String date, BankName? bankName, EmoneyName? emoneyName}) {
    var deposit = '';

    if (bankName != null) {
      deposit = '${bankName.depositType}-${bankName.id}';
    }

    if (emoneyName != null) {
      deposit = '${emoneyName.depositType}-${emoneyName.id}';
    }

    return getDataCell(data: _getBankPriceData(date: date, deposit: deposit).toString().toCurrency(), width: 70, alignment: Alignment.topRight);
  }

  ///
  Widget getDataCell({required String data, required double width, required Alignment alignment}) {
    return Container(
      width: width,
      margin: const EdgeInsets.all(2),
      alignment: alignment,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.2), width: 2))),
      child: Text(data),
    );
  }

  ///
  Future<void> outputCsv() async {
    if (outputValuesList.isEmpty) {
      getErrorDialog(title: '出力できません。', content: '出力するデータを正しく選択してください。');

      return;
    }

    var dataType = ref.watch(dataDownloadProvider.select((value) => value.dataType));

    final now = DateTime.now();
    final timeFormat = DateFormat('HHmmss');
    final currentTime = timeFormat.format(now);

    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');

    final dateStr = '${dataType!.japanName}_${year}${month}${day}$currentTime';
    final sendFileName = '$dateStr.csv';

    final exFilePath = '$externalStoragePublicDirectoryPath/$sendFileName';
    final textFilePath = File(exFilePath);
    await textFilePath.writeAsString(outputValuesList.join('\n'));

    //
    // CharsetConverter.decode('Shift_JIS', outputValuesList.join('\n'))
    // await textFilePath.writeAsString(CharsetConverter.decode('Shift_JIS', outputValuesList.join('\n')));

    //  final result = await CharsetConverter.encode(charset, input!)

//    await textFilePath.writeAsString(CharsetConverter.encode('Shift_JIS', outputValuesList.join('\n')) as String);
  }
}
