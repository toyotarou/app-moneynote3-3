import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../collections/money.dart';
import '../../extensions/extensions.dart';
import '../../model/money_model.dart';
import '../../repository/moneys_repository.dart';

class DateMoneyRepairAlert extends StatefulWidget {
  const DateMoneyRepairAlert({super.key, required this.date, required this.isar});

  final DateTime date;
  final Isar isar;

  @override
  State<DateMoneyRepairAlert> createState() => _DateMoneyRepairAlertState();
}

class _DateMoneyRepairAlertState extends State<DateMoneyRepairAlert> {
  DateTime? selectedDate;

  List<MoneyModel> moneyModelList = <MoneyModel>[];

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
                          // ElevatedButton(
                          //   onPressed: () {},
                          //   style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                          //   child: const Text('call'),
                          // ),
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

    if (selectedDate != null) {
      MoneysRepository()
          .getAfterDateMoneyList(isar: widget.isar, date: selectedDate!.yyyymmdd)
          .then((List<Money>? value) {
        if (mounted) {
          setState(() {
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

                moneyModelList.add(moneyModel);
              }
            }
          });
        }
      });
    }
  }

  ///
  Widget _displayAfterMoneyList() {
    final List<Widget> list = <Widget>[];

    for (final MoneyModel element in moneyModelList) {
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(element.date),
          Container(),
        ],
      ));
    }

    return SingleChildScrollView(child: Column(children: list));
  }
}
