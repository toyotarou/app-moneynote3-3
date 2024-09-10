import 'dart:typed_data';

import 'package:charset_converter/charset_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import '../../../collections/bank_name.dart';
import '../../../collections/bank_price.dart';
import '../../../collections/emoney_name.dart';
import '../../../collections/income.dart';
import '../../../collections/money.dart';
import '../../../collections/spend_item.dart';
import '../../../collections/spend_time_place.dart';
import '../../../repository/bank_names_repository.dart';
import '../../../repository/bank_prices_repository.dart';
import '../../../repository/emoney_names_repository.dart';
import '../../../repository/incomes_repository.dart';
import '../../../repository/moneys_repository.dart';
import '../../../repository/spend_items_repository.dart';
import '../../../repository/spend_time_places_repository.dart';
import '../parts/error_dialog.dart';

part '___dummy_download_alert.freezed.dart';

part '___dummy_download_alert.g.dart';

class DummyDownloadAlert extends ConsumerStatefulWidget {
  const DummyDownloadAlert({super.key, required this.isar});

  final Isar isar;

  @override
  ConsumerState<DummyDownloadAlert> createState() => _DummyDownloadAlertState();
}

class _DummyDownloadAlertState extends ConsumerState<DummyDownloadAlert> {
  List<String> outputValuesList = <String>[];

  List<XFile> sendFileList = <XFile>[];
  List<String> sendFileNameList = <String>[];

  List<String> displayFileNameList = <String>[];

  ///
  @override
  void initState() {
    super.initState();

    outputValuesList.clear();

    sendFileNameList.clear();
    sendFileList.clear();

    displayFileNameList.clear();
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
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(dummyDownloadProvider.notifier)
                        .setCsvName(csvName: 'bankName');
                  },
                  child: const Text('bankName'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(dummyDownloadProvider.notifier)
                        .setCsvName(csvName: 'bankPrice');
                  },
                  child: const Text('bankPrice'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(dummyDownloadProvider.notifier)
                        .setCsvName(csvName: 'emoneyName');
                  },
                  child: const Text('emoneyName'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(dummyDownloadProvider.notifier)
                        .setCsvName(csvName: 'income');
                  },
                  child: const Text('income'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(dummyDownloadProvider.notifier)
                        .setCsvName(csvName: 'money');
                  },
                  child: const Text('money'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(dummyDownloadProvider.notifier)
                        .setCsvName(csvName: 'spendItem');
                  },
                  child: const Text('spendItem'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(dummyDownloadProvider.notifier)
                        .setCsvName(csvName: 'spendTimePlace');
                  },
                  child: const Text('spendTimePlace'),
                ),
                const SizedBox(height: 10),
                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                ElevatedButton(
                  onPressed: () => csvOutput(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                  child: const Text('csv output'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => csvSend(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                  child: const Text('csv send'),
                ),
                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: displayFileNameList.map((String e) {
                    return Text(e);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Future<void> csvOutput() async {
    outputValuesList.clear();

    final String csvName = ref.watch(dummyDownloadProvider
        .select((DummyDownloadState value) => value.csvName));

    if (csvName == '') {
      getErrorDialog(title: '出力できません。', content: '出力するデータを正しく選択してください。');

      return;
    }

    switch (csvName) {
      case 'bankName':
        await BankNamesRepository()
            .getBankNameList(isar: widget.isar)
            .then((List<BankName>? value) {
          value?.forEach((BankName element) {
            outputValuesList.add(<String>[
              element.id.toString(),
              element.bankNumber,
              element.bankName,
              element.branchNumber,
              element.branchName,
              element.accountType,
              element.accountNumber,
              element.depositType,
            ].join(','));
          });
        });

      case 'bankPrice':
        await BankPricesRepository()
            .getBankPriceList(isar: widget.isar)
            .then((List<BankPrice>? value) {
          value?.forEach((BankPrice element) {
            outputValuesList.add(<String>[
              element.id.toString(),
              element.date,
              element.depositType,
              element.bankId.toString(),
              element.price.toString(),
            ].join(','));
          });
        });

      case 'emoneyName':
        await EmoneyNamesRepository()
            .getEmoneyNameList(isar: widget.isar)
            .then((List<EmoneyName>? value) {
          value?.forEach((EmoneyName element) {
            outputValuesList.add(<String>[
              element.id.toString(),
              element.emoneyName,
              element.depositType,
            ].join(','));
          });
        });

      case 'income':
        await IncomesRepository()
            .getIncomeList(isar: widget.isar)
            .then((List<Income>? value) {
          value?.forEach((Income element) {
            outputValuesList.add(<String>[
              element.id.toString(),
              element.date,
              element.sourceName,
              element.price.toString(),
            ].join(','));
          });
        });

      case 'money':
        await MoneysRepository()
            .getMoneyList(isar: widget.isar)
            .then((List<Money>? value) {
          value?.forEach((Money element) {
            outputValuesList.add(<String>[
              element.id.toString(),
              element.date,
              element.yen_10000.toString(),
              element.yen_5000.toString(),
              element.yen_2000.toString(),
              element.yen_1000.toString(),
              element.yen_500.toString(),
              element.yen_100.toString(),
              element.yen_50.toString(),
              element.yen_10.toString(),
              element.yen_5.toString(),
              element.yen_1.toString(),
            ].join(','));
          });
        });

      case 'spendItem':
        await SpendItemsRepository()
            .getSpendItemList(isar: widget.isar)
            .then((List<SpendItem>? value) {
          value?.forEach((SpendItem element) {
            outputValuesList.add(<String>[
              element.id.toString(),
              element.spendItemName,
              element.order.toString(),
              element.color,
              element.defaultTime,
            ].join(','));
          });
        });

      case 'spendTimePlace':
        await SpendTimePlacesRepository()
            .getSpendTimePlaceList(isar: widget.isar)
            .then((List<SpendTimePlace>? value) {
          value?.forEach((SpendTimePlace element) {
            outputValuesList.add(<String>[
              element.id.toString(),
              element.date,
              element.spendType,
              element.time,
              element.place,
              element.price.toString(),
            ].join(','));
          });
        });
    }

    final DateTime now = DateTime.now();
    final DateFormat timeFormat = DateFormat('HHmmss');
    final String currentTime = timeFormat.format(now);

    final String year = now.year.toString();
    final String month = now.month.toString().padLeft(2, '0');
    final String day = now.day.toString().padLeft(2, '0');

    final String dateStr = '${csvName}_$year$month$day$currentTime';
    final String sendFileName = '$dateStr.csv';

    final String contents = outputValuesList.join('\n');

    final Uint8List encoded =
        await CharsetConverter.encode('Shift_JIS', contents);

    sendFileNameList.add(sendFileName);
    sendFileList.add(XFile.fromData(encoded, mimeType: 'text/plain'));

    setState(() {
      displayFileNameList = sendFileNameList;
    });

    getErrorDialog(title: 'ファイルを追加しました。', content: 'CSV送信の準備ができました。');
  }

  ///
  void getErrorDialog({required String title, required String content}) {
    // ignore: always_specify_types
    Future.delayed(
      Duration.zero,
      () => error_dialog(context: context, title: title, content: content),
    );
  }

  ///
  Future<void> csvSend() async {
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

@freezed
class DummyDownloadState with _$DummyDownloadState {
  const factory DummyDownloadState({
    @Default('') String csvName,
  }) = _DummyDownloadState;
}

@riverpod
class DummyDownload extends _$DummyDownload {
  ///
  @override
  DummyDownloadState build() {
    return const DummyDownloadState();
  }

  ///
  void setCsvName({required String csvName}) {
    state = state.copyWith(csvName: csvName);
  }
}
