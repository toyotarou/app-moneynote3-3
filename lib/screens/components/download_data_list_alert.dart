import 'package:charset_converter/charset_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:share_plus/share_plus.dart';

import '../../collections/bank_name.dart';
import '../../collections/emoney_name.dart';
import '../../collections/income.dart';
import '../../collections/money.dart';
import '../../collections/spend_item.dart';
import '../../collections/spend_time_place.dart';
import '../../enums/data_download_data_type.dart';
import '../../enums/data_download_date_type.dart';
import '../../extensions/extensions.dart';
import '../../state/data_download/data_download_notifier.dart';
import '../../state/data_download/data_download_response_state.dart';
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
    required this.spendItem,
    required this.incomeList,
  });

  final Isar isar;
  final Map<String, Money> moneyMap;
  final List<SpendTimePlace> allSpendTimePlaceList;
  final List<BankName> bankNameList;
  final List<EmoneyName> emoneyNameList;
  final Map<String, Map<String, int>> bankPricePadMap;
  final List<SpendItem> spendItem;
  final List<Income> incomeList;

  ///
  @override
  ConsumerState<DownloadDataListAlert> createState() =>
      _DownloadDataListAlertState();
}

class _DownloadDataListAlertState extends ConsumerState<DownloadDataListAlert> {
  Map<String, List<SpendTimePlace>> spendTimePlaceMap =
      <String, List<SpendTimePlace>>{};

  List<String> outputValuesList = <String>[];

  List<XFile> sendFileList = <XFile>[];
  List<String> sendFileNameList = <String>[];

  ///
  @override
  void initState() {
    super.initState();

    for (final SpendTimePlace element in widget.allSpendTimePlaceList) {
      spendTimePlaceMap[element.date] = <SpendTimePlace>[];
    }
    for (final SpendTimePlace element in widget.allSpendTimePlaceList) {
      spendTimePlaceMap[element.date]?.add(element);
    }

    outputValuesList.clear();

    sendFileNameList.clear();
    sendFileList.clear();
  }

  ///
  @override
  Widget build(BuildContext context) {
    final DataDownloadResponseState dataDownloadState =
        ref.watch(dataDownloadProvider);

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
                children: <Widget>[const Text('ダウンロードデータ選択'), Container()],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Row(
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: (dataDownloadState.dataType ==
                                DateDownloadDataType.bankName)
                            ? Colors.yellowAccent.withOpacity(0.3)
                            : Colors.pinkAccent.withOpacity(0.2)),
                    onPressed: () {
                      ref
                          .read(dataDownloadProvider.notifier)
                          .setDataType(dataType: DateDownloadDataType.bankName);
                    },
                    child:
                        const Text('bank name', style: TextStyle(fontSize: 10)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: (dataDownloadState.dataType ==
                                DateDownloadDataType.spendItem)
                            ? Colors.yellowAccent.withOpacity(0.3)
                            : Colors.pinkAccent.withOpacity(0.2)),
                    onPressed: () {
                      ref.read(dataDownloadProvider.notifier).setDataType(
                          dataType: DateDownloadDataType.spendItem);
                    },
                    child: const Text('spend item',
                        style: TextStyle(fontSize: 10)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: (dataDownloadState.dataType ==
                                DateDownloadDataType.income)
                            ? Colors.yellowAccent.withOpacity(0.3)
                            : Colors.pinkAccent.withOpacity(0.2)),
                    onPressed: () {
                      ref
                          .read(dataDownloadProvider.notifier)
                          .setDataType(dataType: DateDownloadDataType.income);
                    },
                    child: const Text('income', style: TextStyle(fontSize: 10)),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.4))),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: context.screenSize.width * 0.3,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  ref
                                      .read(dataDownloadProvider.notifier)
                                      .setDataType(
                                          dataType: DateDownloadDataType.none);

                                  _showDP(pos: DateDownloadDateType.start);
                                },
                                icon: Icon(Icons.calendar_month,
                                    color: Colors.greenAccent.withOpacity(0.6)),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text('Start'),
                                  Text(dataDownloadState.startDate)
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('〜'),
                        Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                ref
                                    .read(dataDownloadProvider.notifier)
                                    .setDataType(
                                        dataType: DateDownloadDataType.none);

                                _showDP(pos: DateDownloadDateType.end);
                              },
                              icon: Icon(Icons.calendar_month,
                                  color: Colors.greenAccent.withOpacity(0.6)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text('End'),
                                Text(dataDownloadState.endDate)
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: (dataDownloadState.dataType ==
                                      DateDownloadDataType.money)
                                  ? Colors.yellowAccent.withOpacity(0.3)
                                  : Colors.pinkAccent.withOpacity(0.2)),
                          onPressed: () {
                            if (dataDownloadState.startDate == '' ||
                                dataDownloadState.endDate == '') {
                              getErrorDialog(
                                  title: '選択できません。',
                                  content: '日付を正しく入力してください。');
                              return;
                            }

                            ref.read(dataDownloadProvider.notifier).setDataType(
                                dataType: DateDownloadDataType.money);
                          },
                          child: const Text('money',
                              style: TextStyle(fontSize: 10)),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: (dataDownloadState.dataType ==
                                      DateDownloadDataType.bank)
                                  ? Colors.yellowAccent.withOpacity(0.3)
                                  : Colors.pinkAccent.withOpacity(0.2)),
                          onPressed: () {
                            if (dataDownloadState.startDate == '' ||
                                dataDownloadState.endDate == '') {
                              getErrorDialog(
                                  title: '選択できません。',
                                  content: '日付を正しく入力してください。');
                              return;
                            }

                            ref.read(dataDownloadProvider.notifier).setDataType(
                                dataType: DateDownloadDataType.bank);
                          },
                          child: const Text('bank',
                              style: TextStyle(fontSize: 10)),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: (dataDownloadState.dataType ==
                                      DateDownloadDataType.spend)
                                  ? Colors.yellowAccent.withOpacity(0.3)
                                  : Colors.pinkAccent.withOpacity(0.2)),
                          onPressed: () {
                            if (dataDownloadState.startDate == '' ||
                                dataDownloadState.endDate == '') {
                              getErrorDialog(
                                  title: '選択できません。',
                                  content: '日付を正しく入力してください。');
                              return;
                            }

                            ref.read(dataDownloadProvider.notifier).setDataType(
                                dataType: DateDownloadDataType.spend);
                          },
                          child: const Text('spend',
                              style: TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(),
                  TextButton(
                    onPressed: outputCsv,
                    child: const Text('CSVを出力する'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(),
                  TextButton(
                    onPressed: sendCsv,
                    child: const Text('CSVを送信する'),
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
    // ignore: always_specify_types
    Future.delayed(
      Duration.zero,
      // ignore: use_build_context_synchronously
      () => error_dialog(context: context, title: title, content: content),
    );
  }

  ///
  Future<void> _showDP({required DateDownloadDateType pos}) async {
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
      switch (pos) {
        case DateDownloadDateType.start:
          await ref
              .read(dataDownloadProvider.notifier)
              .setStartDate(date: selectedDate.yyyymmdd);
        case DateDownloadDateType.end:
          await ref
              .read(dataDownloadProvider.notifier)
              .setEndDate(date: selectedDate.yyyymmdd);
      }
    }
  }

  ///
  Widget _displayDownloadData() {
    final List<Widget> list = <Widget>[];

    final DataDownloadResponseState dataDownloadState =
        ref.watch(dataDownloadProvider);

    if (dataDownloadState.dataType != null) {
      //=====================//
      final List<String> dateList = <String>[];

      if (dataDownloadState.endDate != '' &&
          dataDownloadState.startDate != '') {
        final int dateDiff =
            DateTime.parse('${dataDownloadState.endDate} 00:00:00')
                .difference(
                    DateTime.parse('${dataDownloadState.startDate} 00:00:00'))
                .inDays;

        for (int i = 0; i <= dateDiff; i++) {
          final DateTime day =
              DateTime.parse('${dataDownloadState.startDate} 00:00:00')
                  .add(Duration(days: i));

          dateList.add(day.yyyymmdd);
        }
      }
      //=====================//

      switch (dataDownloadState.dataType!) {
        case DateDownloadDataType.none:
          break;

        case DateDownloadDataType.money:
          outputValuesList = <String>[];

          widget.moneyMap.forEach((String key, Money value) {
            if (dateList.contains(key)) {
              list.add(Row(
                children: <Widget>[
                  getDataCell(
                      data: value.date,
                      width: 100,
                      alignment: Alignment.topLeft),
                  getDataCell(
                      data: value.yen_10000.toString().toCurrency(),
                      width: 50,
                      alignment: Alignment.topRight),
                  getDataCell(
                      data: value.yen_5000.toString().toCurrency(),
                      width: 50,
                      alignment: Alignment.topRight),
                  getDataCell(
                      data: value.yen_2000.toString().toCurrency(),
                      width: 50,
                      alignment: Alignment.topRight),
                  getDataCell(
                      data: value.yen_1000.toString().toCurrency(),
                      width: 50,
                      alignment: Alignment.topRight),
                  getDataCell(
                      data: value.yen_500.toString().toCurrency(),
                      width: 50,
                      alignment: Alignment.topRight),
                  getDataCell(
                      data: value.yen_100.toString().toCurrency(),
                      width: 50,
                      alignment: Alignment.topRight),
                  getDataCell(
                      data: value.yen_50.toString().toCurrency(),
                      width: 50,
                      alignment: Alignment.topRight),
                  getDataCell(
                      data: value.yen_10.toString().toCurrency(),
                      width: 50,
                      alignment: Alignment.topRight),
                  getDataCell(
                      data: value.yen_5.toString().toCurrency(),
                      width: 50,
                      alignment: Alignment.topRight),
                  getDataCell(
                      data: value.yen_1.toString().toCurrency(),
                      width: 50,
                      alignment: Alignment.topRight),
                ],
              ));

              outputValuesList.add(<String>[
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

        case DateDownloadDataType.bank:
          outputValuesList = <String>[];

          for (final String element in dateList) {
            list.add(
              Row(children: <Widget>[
                getDataCell(
                    data: element, width: 100, alignment: Alignment.topLeft),
                Row(
                    children: widget.bankNameList
                        .map((BankName e) => _displayBankPriceListData(
                            date: element, bankName: e))
                        .toList()),
                Row(
                    children: widget.emoneyNameList
                        .map((EmoneyName e) => _displayBankPriceListData(
                            date: element, emoneyName: e))
                        .toList())
              ]),
            );

            final List<String> outVal = <String>[element];
            for (final BankName element2 in widget.bankNameList) {
              outVal.add(_getBankPriceData(
                      deposit: '${element2.depositType}-${element2.id}',
                      date: element)
                  .toString());
            }
            for (final EmoneyName element2 in widget.emoneyNameList) {
              outVal.add(_getBankPriceData(
                      deposit: '${element2.depositType}-${element2.id}',
                      date: element)
                  .toString());
            }

            outputValuesList.add(outVal.join(','));
          }

        case DateDownloadDataType.spend:
          outputValuesList = <String>[];

          spendTimePlaceMap.forEach((String key, List<SpendTimePlace> value) {
            if (dateList.contains(key)) {
              for (final SpendTimePlace element in value) {
                list.add(Row(
                  children: <Widget>[
                    getDataCell(
                        data: element.date,
                        width: 100,
                        alignment: Alignment.topLeft),
                    getDataCell(
                        data: element.time,
                        width: 60,
                        alignment: Alignment.topLeft),
                    getDataCell(
                        data: element.spendType,
                        width: 120,
                        alignment: Alignment.topLeft),
                    getDataCell(
                        data: element.price.toString().toCurrency(),
                        width: 80,
                        alignment: Alignment.topRight),
                    getDataCell(
                        data: element.place,
                        width: 200,
                        alignment: Alignment.topLeft),
                  ],
                ));

                outputValuesList.add(<String>[
                  element.date,
                  element.time,
                  element.spendType,
                  element.price.toString(),
                  element.place
                ].join(','));
              }
            }
          });

        case DateDownloadDataType.bankName:
          outputValuesList = <String>[];

          for (final BankName element in widget.bankNameList) {
            list.add(Row(
              children: <Widget>[
                getDataCell(
                    data: element.bankNumber,
                    width: 100,
                    alignment: Alignment.topLeft),
                getDataCell(
                    data: element.bankName,
                    width: 100,
                    alignment: Alignment.topLeft),
                getDataCell(
                    data: element.branchNumber,
                    width: 100,
                    alignment: Alignment.topLeft),
                getDataCell(
                    data: element.branchName,
                    width: 100,
                    alignment: Alignment.topLeft),
                getDataCell(
                    data: element.accountType,
                    width: 100,
                    alignment: Alignment.topLeft),
                getDataCell(
                    data: element.accountNumber,
                    width: 100,
                    alignment: Alignment.topLeft),
              ],
            ));

            outputValuesList.add(<String>[
              "'${element.bankNumber}",
              element.bankName,
              "'${element.branchNumber}",
              element.branchName,
              element.accountType,
              "'${element.accountNumber}",
            ].join(','));
          }

          for (final EmoneyName element in widget.emoneyNameList) {
            list.add(Row(
              children: <Widget>[
                getDataCell(
                    data: element.emoneyName,
                    width: 100,
                    alignment: Alignment.topLeft),
              ],
            ));

            outputValuesList.add(<String>[element.emoneyName].join(','));
          }


        case DateDownloadDataType.spendItem:
          outputValuesList = <String>[];

          for (final SpendItem element in widget.spendItem) {
            list.add(Row(
              children: <Widget>[
                getDataCell(
                    data: element.spendItemName,
                    width: 100,
                    alignment: Alignment.topLeft),
                getDataCell(
                    data: element.order.toString(),
                    width: 100,
                    alignment: Alignment.topLeft),
                getDataCell(
                    data: element.color,
                    width: 100,
                    alignment: Alignment.topLeft),
                getDataCell(
                    data: element.defaultTime,
                    width: 100,
                    alignment: Alignment.topLeft),
              ],
            ));

            outputValuesList.add(<String>[
              element.spendItemName,
              element.order.toString(),
              "'${element.color}",
              element.defaultTime
            ].join(','));
          }


        case DateDownloadDataType.income:
          outputValuesList = <String>[];

          for (final Income element in widget.incomeList) {
            list.add(Row(
              children: <Widget>[
                getDataCell(
                    data: element.date,
                    width: 100,
                    alignment: Alignment.topLeft),
                getDataCell(
                    data: element.sourceName,
                    width: 200,
                    alignment: Alignment.topLeft),
                getDataCell(
                    data: element.price.toString(),
                    width: 100,
                    alignment: Alignment.topRight),
              ],
            ));

            outputValuesList.add(<Object>[
              element.date,
              element.sourceName,
              element.price
            ].join(','));
          }

      }
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: list,
        ),
      ),
    );
  }

  ///
  int _getBankPriceData({required String deposit, required String date}) {
    int dispPrice = 0;
    if (widget.bankPricePadMap[deposit] != null) {
      if (widget.bankPricePadMap[deposit]![date] != null) {
        dispPrice = widget.bankPricePadMap[deposit]![date]!;
      }
    }

    return dispPrice;
  }

  ///
  Widget _displayBankPriceListData(
      {required String date, BankName? bankName, EmoneyName? emoneyName}) {
    String deposit = '';

    if (bankName != null) {
      deposit = '${bankName.depositType}-${bankName.id}';
    }

    if (emoneyName != null) {
      deposit = '${emoneyName.depositType}-${emoneyName.id}';
    }

    return getDataCell(
        data: _getBankPriceData(date: date, deposit: deposit)
            .toString()
            .toCurrency(),
        width: 70,
        alignment: Alignment.topRight);
  }

  ///
  Widget getDataCell(
      {required String data,
      required double width,
      required Alignment alignment}) {
    return Container(
      width: width,
      margin: const EdgeInsets.all(2),
      alignment: alignment,
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(color: Colors.white.withOpacity(0.2), width: 2))),
      child: Text(data),
    );
  }

  ///
  Future<void> outputCsv() async {
    if (outputValuesList.isEmpty) {
      getErrorDialog(title: '出力できません。', content: '出力するデータを正しく選択してください。');

      return;
    }

    final DateDownloadDataType? dataType = ref.watch(dataDownloadProvider
        .select((DataDownloadResponseState value) => value.dataType));

    final DateTime now = DateTime.now();
    final DateFormat timeFormat = DateFormat('HHmmss');
    final String currentTime = timeFormat.format(now);

    final String year = now.year.toString();
    final String month = now.month.toString().padLeft(2, '0');
    final String day = now.day.toString().padLeft(2, '0');

    final String dateStr = '${dataType!.japanName}_$year$month$day$currentTime';
    final String sendFileName = '$dateStr.csv';

    final String contents = outputValuesList.join('\n');

    final Uint8List encoded =
        await CharsetConverter.encode('Shift_JIS', contents);

    sendFileNameList.add(sendFileName);
    sendFileList.add(XFile.fromData(encoded, mimeType: 'text/plain'));

    getErrorDialog(title: 'ファイルを追加しました。', content: 'CSV送信の準備ができました。');
  }

  ///
  Future<void> sendCsv() async {
    if (sendFileList.isEmpty || sendFileNameList.isEmpty) {
      getErrorDialog(title: '送信できません。', content: '送信するデータを正しく選択してください。');

      return;
    }

    final RenderBox? box = context.findRenderObject() as RenderBox?;

    await Share.shareXFiles(
      sendFileList,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      fileNameOverrides: sendFileNameList,
    );

    if (mounted) {
      outputValuesList.clear();

      sendFileNameList.clear();
      sendFileList.clear();

      Navigator.pop(context);
    }
  }
}
