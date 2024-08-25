import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:money_note/collections/spend_item.dart';
import 'package:money_note/collections/spend_time_place.dart';
import 'package:money_note/extensions/extensions.dart';

class EachMonthItemSummaryPage extends ConsumerStatefulWidget {
  const EachMonthItemSummaryPage(
      {super.key,
      required this.year,
      required this.spendTimePlaceList,
      required this.spendItemList});

  final int year;
  final List<SpendTimePlace> spendTimePlaceList;
  final List<SpendItem> spendItemList;

  @override
  ConsumerState<EachMonthItemSummaryPage> createState() =>
      _EachMonthItemSummaryPageState();
}

class _EachMonthItemSummaryPageState
    extends ConsumerState<EachMonthItemSummaryPage> {
  List<SpendTimePlace> stpList = [];

  ///
  @override
  void initState() {
    super.initState();

    stpList = widget.spendTimePlaceList
        .where((element) => element.date.split('-')[0].toInt() == widget.year)
        .toList();
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
              Expanded(child: displayEachMonthItemSummary()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget displayEachMonthItemSummary() {
    final list = <Widget>[];

    final map = <int, Map<String, int>>{};

    for (var i = 1; i <= 12; i++) {
      final map2 = <String, List<int>>{};

      widget.spendItemList
          .forEach((element2) => map2[element2.spendItemName] = []);

      stpList.forEach((element) {
        final exDate = element.date.split('-');
        final elementYearmonth = '${exDate[0]}-${exDate[1]}';
        final widgetYearmonth =
            '${widget.year}-${i.toString().padLeft(2, '0')}';

        if (elementYearmonth == widgetYearmonth) {
          widget.spendItemList.forEach((element2) {
            if (element2.spendItemName == element.spendType) {
              map2[element2.spendItemName]?.add(element.price);
            }
          });
        }
      });

      final map3 = <String, int>{};

      widget.spendItemList
          .forEach((element4) => map3[element4.spendItemName] = 0);

      map2.forEach((key, value) {
        var sum = 0;
        value.forEach((element3) => sum += element3);
        map3[key] = sum;
      });

      map[i] = map3;
    }

    final list2 = <Widget>[];
    for (var i = 1; i <= 12; i++) {
      final list3 = <Widget>[
        SizedBox(
          width: 100,
          height: 30,
          child: Text(i.toString().padLeft(2, '0')),
        ),
      ];
      widget.spendItemList.forEach((element5) {
        list3.add(Container(
          width: 100,
          height: 40,
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(element5.spendItemName),
              Container(
                alignment: Alignment.topRight,
                child: Text(
                  (map[i] != null && map[i]![element5.spendItemName] != null)
                      ? map[i]![element5.spendItemName]!.toString().toCurrency()
                      : '',
                ),
              ),
            ],
          ),
        ));
      });
      list2.add(Column(children: list3));
    }

    list.add(Row(children: list2));

/*
I/flutter (11388): {
1: {
楽天キャッシュ: 0,
食費: 22216,
交通費: 8814,
クレジット: 179349,
雑費: 1642, お賽銭: 1320, 遊興費: 2000, 交際費: 6814, 投資: 43333, お使い: 0, 支払い: 1600, 医療費: 0, 通信費: 204, 手数料: 220, 教育費: 0, 美容費: 2200, ジム会費: 0, 設備費: 0, 被服費: 0, 保険料: 3787, 年金保険: 55880, 共済代: 3000, 国民年金基金: 26625, 国民健康保険: 51100, 税金: 201900, 国民年金: 0, 不明: 0, プラス: -14001, 収入: -650000, 利息: 0, 送金: 0, 水道光熱費: 5314, 住居費: 134000},
2: {楽天キャッシュ: 0, 食費: 29369, 交通費: 7640, クレジット: 179863, 雑費: 12940, お賽銭: 2075, 遊興費: 1000, 交際費: 16296, 投資: 43333, お使い: 4988, 支払い: 33000, 医療費: 6890, 通信費: 0, 手数料: 528, 教育費: 0, 美容費: 0, ジム会費: 0, 設備費: 0, 被服費: 0, 保険料: 3787, 年金保険: 55880, 共済代: 3000, 国民年金基金: 26625, 国民健康保険: 16940, 税金: 0, 国�
    */

    /*


    for (var i = 0; i < 5; i++) {
      var list2 = <Widget>[];
      for (var j = 0; j < 5; j++) {
        list2.add(Container(
          decoration: const BoxDecoration(color: Colors.redAccent),
          height: 300,
          width: 300,
          margin: const EdgeInsets.all(10),
        ));
      }

      list.add(Row(children: list2));
    }




    */

    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(children: list),
      ),
    );
  }
}
