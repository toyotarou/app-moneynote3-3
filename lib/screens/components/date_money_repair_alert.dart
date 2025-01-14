import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../collections/money.dart';
import '../../extensions/extensions.dart';
import '../../model/money_model.dart';
import '../../repository/moneys_repository.dart';
import '../../state/app_params/app_params_notifier.dart';
import '../../state/money_repair/money_repair.dart';
import 'parts/error_dialog.dart';

class DateMoneyRepairAlert extends ConsumerStatefulWidget {
  const DateMoneyRepairAlert({super.key, required this.date, required this.isar});

  final DateTime date;
  final Isar isar;

  @override
  ConsumerState<DateMoneyRepairAlert> createState() => _DateMoneyRepairAlertState();
}

class _DateMoneyRepairAlertState extends ConsumerState<DateMoneyRepairAlert> {
  DateTime? selectedDate;

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('金種枚数修正'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('開始日付'),
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => _showDP(),
                            child: Icon(Icons.calendar_month, color: Colors.greenAccent.withOpacity(0.6)),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: 100,
                            child: Text((selectedDate == null) ? '-' : selectedDate!.yyyymmdd),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              callMoneyRecord();
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                            child: const Text('call'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(child: _displayAfterMoneyList()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _showDP() async {
    selectedDate = await showDatePicker(
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

    setState(() {});

    // if (selectedDate != null) {
    //   MoneysRepository().getAfterDateMoneyList(isar: widget.isar, date: selectedDate!.yyyymmdd).then(
    //     (List<Money>? value) async {
    //       if (value!.isNotEmpty) {
    //         for (int i = 0; i < value.length; i++) {
    //           final MoneyModel moneyModel = MoneyModel(
    //             date: value[i].date,
    //             yen_10000: value[i].yen_10000,
    //             yen_5000: value[i].yen_5000,
    //             yen_2000: value[i].yen_2000,
    //             yen_1000: value[i].yen_1000,
    //             yen_500: value[i].yen_500,
    //             yen_100: value[i].yen_100,
    //             yen_50: value[i].yen_50,
    //             yen_10: value[i].yen_10,
    //             yen_5: value[i].yen_5,
    //             yen_1: value[i].yen_1,
    //           );
    //
    //           await ref
    //               .read(moneyRepairControllerProvider.notifier)
    //               .replaceMoneyModelListData(pos: i, moneyModel: moneyModel);
    //         }
    //       }
    //     },
    //   );
    // }
    //
    //
    //
  }

  ///
  Future<void> callMoneyRecord() async {
    if (selectedDate == null) {
      // ignore: always_specify_types
      Future.delayed(
        Duration.zero,
        () => error_dialog(
            // ignore: use_build_context_synchronously
            context: context,
            title: '表示できません。',
            content: '日付を設定してください。'),
      );

      return;
    }

    MoneysRepository().getAfterDateMoneyList(isar: widget.isar, date: selectedDate!.yyyymmdd).then(
      (List<Money>? value) async {
        if (value!.isNotEmpty) {
          for (int i = 0; i < value.length; i++) {
            final MoneyModel moneyModel = MoneyModel(
              date: value[i].date,
              yen_10000: value[i].yen_10000,
              yen_5000: value[i].yen_5000,
              yen_2000: value[i].yen_2000,
              yen_1000: value[i].yen_1000,
              yen_500: value[i].yen_500,
              yen_100: value[i].yen_100,
              yen_50: value[i].yen_50,
              yen_10: value[i].yen_10,
              yen_5: value[i].yen_5,
              yen_1: value[i].yen_1,
            );

            await ref
                .read(moneyRepairControllerProvider.notifier)
                .replaceMoneyModelListData(pos: i, moneyModel: moneyModel);
          }
        }
      },
    );
  }

  ///
  Widget _displayAfterMoneyList() {
    final List<Widget> list = <Widget>[];

    final appParamState = ref.watch(appParamProvider);

    final List<MoneyModel> moneyModelList =
        ref.watch(moneyRepairControllerProvider.select((MoneyRepairControllerState value) => value.moneyModelList));

    for (int i = 0; i < moneyModelList.length; i++) {
      if (moneyModelList[i].date != '') {
        list.add(Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(moneyModelList[i].date),
                Container(),
              ],
            ),
            Row(
              children: <int>[
                moneyModelList[i].yen_10000,
                moneyModelList[i].yen_5000,
                moneyModelList[i].yen_2000,
                moneyModelList[i].yen_1000,
                moneyModelList[i].yen_500,
                moneyModelList[i].yen_100,
                moneyModelList[i].yen_50,
                moneyModelList[i].yen_10,
                moneyModelList[i].yen_5,
                moneyModelList[i].yen_1,
              ].asMap().entries.map(
                (MapEntry<int, int> e) {
                  return GestureDetector(
                    onTap: () {
                      print('${e.key} / ${e.value} | ${moneyModelList[i].date} || $i');

                      /*
                      I/flutter ( 7303): 0 / 15 | 2025-01-01 || 0




                      */

                      ref
                          .read(appParamProvider.notifier)
                          .setRepairSelectValue(date: moneyModelList[i].date, kind: e.key);
                    },
                    child: Container(
                      width: context.screenSize.width / 16,
                      margin: const EdgeInsets.all(2),
                      padding: const EdgeInsets.all(2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                        color: (appParamState.repairSelectDate == moneyModelList[i].date &&
                                appParamState.repairSelectKind == e.key)
                            ? Colors.yellowAccent.withOpacity(0.2)
                            : Colors.transparent,
                      ),
                      child: Text(e.value.toString(), style: const TextStyle(fontSize: 8)),
                    ),
                  );
                },
              ).toList(),
            ),
            Divider(color: Colors.white.withOpacity(0.3), thickness: 3),
          ],
        ));
      }
    }

    return SingleChildScrollView(child: Column(children: list));
  }
}
