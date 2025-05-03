import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../collections/money.dart';
import '../../controllers/app_params/app_params_response_state.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../model/money_model.dart';
import '../../repository/moneys_repository.dart';

import 'parts/error_dialog.dart';
import 'parts/money_overlay.dart';

class DateMoneyRepairAlert extends ConsumerStatefulWidget {
  const DateMoneyRepairAlert({super.key, required this.date, required this.isar});

  final DateTime date;
  final Isar isar;

  @override
  ConsumerState<DateMoneyRepairAlert> createState() => _DateMoneyRepairAlertState();
}

class _DateMoneyRepairAlertState extends ConsumerState<DateMoneyRepairAlert>
    with ControllersMixin<DateMoneyRepairAlert> {
  DateTime? selectedDate;

  final List<OverlayEntry> _bigEntries = <OverlayEntry>[];

  List<String> moneyKindList = <String>['10000', '5000', '2000', '1000', '500', '100', '50', '10', '5', '1'];

  TextEditingController repairCountEditingController = TextEditingController();

  int moneyModelListLength = 0;

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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text('金種枚数修正'), SizedBox.shrink()],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('開始日付'),
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              moneyRepairControllerNotifier.clearMoneyModelListData();

                              _showDP();
                            },
                            child: Icon(Icons.calendar_month, color: Colors.greenAccent.withOpacity(0.6)),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: 70,
                            child: Text(
                              (selectedDate == null) ? '-' : selectedDate!.yyyymmdd,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => callMoneyRecord(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                    child: const Text('call'),
                  ),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(child: _displayAfterMoneyList()),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Center(
                child: ElevatedButton(
                  onPressed: () => replaceIsarMoneyRecord(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                  child: const Text('isarデータ変更'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Future<void> replaceIsarMoneyRecord() async {
    if (appParamState.selectedRepairRecordNumber.isEmpty) {
      // ignore: always_specify_types
      Future.delayed(
        Duration.zero,
        () => error_dialog(
            // ignore: use_build_context_synchronously
            context: context,
            title: '変更できません。',
            content: '変更するレコードが設定されていません。'),
      );

      return;
    }

    //===================================================

    appParamState.selectedRepairRecordNumber.toSet().toList().forEach((int element) async {
      await widget.isar.writeTxn(() async {
        final MoneyModel moneyModel = moneyRepairControllerState.moneyModelList[element];

        await MoneysRepository().getDateMoney(
            isar: widget.isar, param: <String, dynamic>{'date': moneyModel.date}).then((Money? value) async {
          value!
            ..date = moneyModel.date
            ..yen_10000 = moneyModel.yen_10000
            ..yen_5000 = moneyModel.yen_5000
            ..yen_2000 = moneyModel.yen_2000
            ..yen_1000 = moneyModel.yen_1000
            ..yen_500 = moneyModel.yen_500
            ..yen_100 = moneyModel.yen_100
            ..yen_50 = moneyModel.yen_50
            ..yen_10 = moneyModel.yen_10
            ..yen_5 = moneyModel.yen_5
            ..yen_1 = moneyModel.yen_1;

          await MoneysRepository().updateMoney(isar: widget.isar, money: value);
        });
      });
    });

    //===================================================

    if (mounted) {
      Navigator.pop(context);

      Navigator.pop(context);
    }
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

            await moneyRepairControllerNotifier.setMoneyModelListData(pos: i, moneyModel: moneyModel);
          }
        }
      },
    );
  }

  ///
  Widget _displayAfterMoneyList() {
    final List<Widget> list = <Widget>[];

    moneyModelListLength = moneyRepairControllerState.moneyModelList.length;

    Offset initialPosition = Offset(context.screenSize.width * 0.6, context.screenSize.height * 0.2);

    if (appParamState.overlayPosition != null) {
      initialPosition = appParamState.overlayPosition!;
    }

    for (int i = 0; i < moneyRepairControllerState.moneyModelList.length; i++) {
      if (moneyRepairControllerState.moneyModelList[i].date != '') {
        list.add(Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(moneyRepairControllerState.moneyModelList[i].date),
                const SizedBox.shrink(),
              ],
            ),
            Row(
              children: <int>[
                moneyRepairControllerState.moneyModelList[i].yen_10000,
                moneyRepairControllerState.moneyModelList[i].yen_5000,
                moneyRepairControllerState.moneyModelList[i].yen_2000,
                moneyRepairControllerState.moneyModelList[i].yen_1000,
                moneyRepairControllerState.moneyModelList[i].yen_500,
                moneyRepairControllerState.moneyModelList[i].yen_100,
                moneyRepairControllerState.moneyModelList[i].yen_50,
                moneyRepairControllerState.moneyModelList[i].yen_10,
                moneyRepairControllerState.moneyModelList[i].yen_5,
                moneyRepairControllerState.moneyModelList[i].yen_1,
              ].asMap().entries.map(
                (MapEntry<int, int> e) {
                  return GestureDetector(
                    onTap: () {
                      repairCountEditingController.clear();

                      appParamNotifier.setRepairSelectValue(
                          date: moneyRepairControllerState.moneyModelList[i].date, kind: e.key);

                      appParamNotifier.setRepairSelectFlag(flag: false);

                      appParamNotifier.setMoneyRepairInputParams(bigEntries: _bigEntries, setStateCallback: setState);

                      addBigOverlay(
                        context: context,
                        bigEntries: _bigEntries,
                        setStateCallback: setState,
                        width: context.screenSize.width * 0.4,
                        height: 260,
                        color: Colors.blueGrey.withOpacity(0.3),
                        initialPosition: initialPosition,
                        widget: Consumer(
                          builder: (BuildContext context, WidgetRef ref, Widget? child) {
                            return displayMoneyRepairInputParts(
                              index: i,
                              date: moneyRepairControllerState.moneyModelList[i].date,
                              data: e,
                              appParamState: appParamState,
                            );
                          },
                        ),
                        onPositionChanged: (Offset newPos) => appParamNotifier.updateOverlayPosition(newPos),
                      );
                    },
                    child: Container(
                      width: context.screenSize.width / 17,
                      margin: const EdgeInsets.all(2),
                      padding: const EdgeInsets.all(2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: (e.key < 4) ? Colors.greenAccent.withOpacity(0.3) : Colors.white.withOpacity(0.3),
                        ),
                        color: (appParamState.repairSelectDate == moneyRepairControllerState.moneyModelList[i].date &&
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

  ///
  Widget displayMoneyRepairInputParts({
    required int index,
    required String date,
    required MapEntry<int, int> data,
    required AppParamsResponseState appParamState,
  }) {
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 12),
      child: Column(
        children: <Widget>[
          //        Text(index.toString()),
          Text(date),
          Text('${moneyKindList[data.key]}円'),
          Text('変更前：${data.value}枚'),
          Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
          TextField(
            keyboardType: TextInputType.number,
            controller: repairCountEditingController,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              hintText: '(枚数)',
              filled: true,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
            ),
            style: const TextStyle(fontSize: 13, color: Colors.white),
            onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
          ),
          Row(
            children: <Widget>[
              IconButton(
                onPressed: () => appParamNotifier.setRepairSelectFlag(flag: !appParamState.repairSelectFlag),
                icon: Icon(
                  Icons.check,
                  color: (appParamState.repairSelectFlag) ? Colors.orangeAccent : Colors.grey,
                ),
              ),
              const Expanded(child: Text('以降の日付にも適用する')),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (appParamState.repairSelectFlag) {
                for (int i = index; i < moneyModelListLength; i++) {
                  appParamNotifier.setSelectedRepairRecordNumber(number: i);
                }
              } else {
                appParamNotifier.setSelectedRepairRecordNumber(number: index);
              }

              moneyRepairControllerNotifier.replaceMoneyModelListData(
                index: index,
                date: date,
                kind: moneyKindList[data.key],
                value: data.value,
                newValue: repairCountEditingController.text.trim(),
                repairSelectFlag: appParamState.repairSelectFlag,
                moneyModelListLength: moneyModelListLength,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
            child: const Text('変更'),
          ),
        ],
      ),
    );
  }
}
