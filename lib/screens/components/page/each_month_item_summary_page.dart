import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../collections/spend_item.dart';
import '../../../collections/spend_time_place.dart';
import '../../../extensions/extensions.dart';

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

      for (var element2 in widget.spendItemList) {
        map2[element2.spendItemName] = [];
      }

      for (var element in stpList) {
        final exDate = element.date.split('-');
        final elementYearmonth = '${exDate[0]}-${exDate[1]}';
        final widgetYearmonth =
            '${widget.year}-${i.toString().padLeft(2, '0')}';

        if (elementYearmonth == widgetYearmonth) {
          for (var element2 in widget.spendItemList) {
            if (element2.spendItemName == element.spendType) {
              map2[element2.spendItemName]?.add(element.price);
            }
          }
        }
      }

      final map3 = <String, int>{};

      for (var element4 in widget.spendItemList) {
        map3[element4.spendItemName] = 0;
      }

      map2.forEach((key, value) {
        var sum = 0;
        for (var element3 in value) {
          sum += element3;
        }
        map3[key] = sum;
      });

      map[i] = map3;
    }

    final list2 = <Widget>[const SizedBox(width: 140)];

    for (var i = 1; i <= 12; i++) {
      final list3 = <Widget>[];

      if (DateTime(widget.year, i).isBefore(DateTime.now())) {
        list3.add(
          Container(
            width: 100,
            height: 30,
            alignment: Alignment.center,
            child: Text(i.toString().padLeft(2, '0')),
          ),
        );

        for (var element5 in widget.spendItemList) {
          list3.add(Container(
            width: 100,
            height: 24,
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Color(element5.color.toInt()).withOpacity(0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(right: 5),
                      child: Text(
                        (map[i] != null &&
                                map[i]![element5.spendItemName] != null)
                            ? map[i]![element5.spendItemName]!
                                .toString()
                                .toCurrency()
                            : '',
                      ),
                    ),
                    Text(
                      i.toString().padLeft(2, '0'),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ));
        }
      }

      list2.add(Column(children: list3));
    }

    list.add(Row(children: list2));

    final underWidget = Column(
      children: [
        const SizedBox(width: 100, height: 30),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.spendItemList.map((e) {
            return Container(
              width: 120,
              height: 24,
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Color(e.color.toInt()).withOpacity(0.1),
              ),
              child: Text(e.spendItemName),
            );
          }).toList(),
        ),
      ],
    );

    return SingleChildScrollView(
      child: Stack(
        children: [
          underWidget,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(children: list),
          ),
        ],
      ),
    );
  }
}
