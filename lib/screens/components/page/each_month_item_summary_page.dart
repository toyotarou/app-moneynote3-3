import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../collections/spend_item.dart';
import '../../../collections/spend_time_place.dart';
import '../../../controllers/controllers_mixin.dart';
import '../../../extensions/extensions.dart';

class EachMonthItemSummaryPage extends ConsumerStatefulWidget {
  const EachMonthItemSummaryPage(
      {super.key, required this.year, required this.spendTimePlaceList, required this.spendItemList});

  final int year;
  final List<SpendTimePlace> spendTimePlaceList;
  final List<SpendItem> spendItemList;

  @override
  ConsumerState<EachMonthItemSummaryPage> createState() => _EachMonthItemSummaryPageState();
}

class _EachMonthItemSummaryPageState extends ConsumerState<EachMonthItemSummaryPage>
    with ControllersMixin<EachMonthItemSummaryPage> {
  List<SpendTimePlace> stpList = <SpendTimePlace>[];

  ///
  @override
  void initState() {
    super.initState();

    stpList = widget.spendTimePlaceList
        .where((SpendTimePlace element) => element.date.split('-')[0].toInt() == widget.year)
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
            children: <Widget>[
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
    final List<Widget> list = <Widget>[];

    final Map<int, Map<String, int>> map = <int, Map<String, int>>{};

    for (int i = 1; i <= 12; i++) {
      final Map<String, List<int>> map2 = <String, List<int>>{};

      for (final SpendItem element2 in widget.spendItemList) {
        map2[element2.spendItemName] = <int>[];
      }

      for (final SpendTimePlace element in stpList) {
        final List<String> exDate = element.date.split('-');
        final String elementYearmonth = '${exDate[0]}-${exDate[1]}';
        final String widgetYearmonth = '${widget.year}-${i.toString().padLeft(2, '0')}';

        if (elementYearmonth == widgetYearmonth) {
          for (final SpendItem element2 in widget.spendItemList) {
            if (element2.spendItemName == element.spendType) {
              map2[element2.spendItemName]?.add(element.price);
            }
          }
        }
      }

      final Map<String, int> map3 = <String, int>{};

      for (final SpendItem element4 in widget.spendItemList) {
        map3[element4.spendItemName] = 0;
      }

      map2.forEach((String key, List<int> value) {
        int sum = 0;
        for (final int element3 in value) {
          sum += element3;
        }
        map3[key] = sum;
      });

      map[i] = map3;
    }

    final List<Widget> list2 = <Widget>[const SizedBox(width: 140)];

    for (int i = 1; i <= 12; i++) {
      final List<Widget> list3 = <Widget>[];

      if (DateTime(widget.year, i).isBefore(DateTime.now())) {
        list3.add(
          GestureDetector(
            onTap: () {
              appParamNotifier.setEachMonthItemSummarySelectedMonth(month: i.toString().padLeft(2, '0'));
            },
            child: Container(
              width: 100,
              height: 30,
              alignment: Alignment.center,
              child: Text(i.toString().padLeft(2, '0')),
            ),
          ),
        );

        for (final SpendItem element5 in widget.spendItemList) {
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
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(right: 5),
                      child: Text(
                        (map[i] != null && map[i]![element5.spendItemName] != null)
                            ? map[i]![element5.spendItemName]!.toString().toCurrency()
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

      list2.add(
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: (appParamState.eachMonthItemSummarySelectedMonth == i.toString().padLeft(2, '0'))
                      ? Colors.yellowAccent.withValues(alpha: 0.4)
                      : Colors.transparent)),
          child: Column(children: list3),
        ),
      );
    }

    list.add(Row(children: list2));

    final Column underWidget = Column(
      children: <Widget>[
        const SizedBox(width: 100, height: 30),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.spendItemList.map((SpendItem e) {
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
        children: <Widget>[
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
