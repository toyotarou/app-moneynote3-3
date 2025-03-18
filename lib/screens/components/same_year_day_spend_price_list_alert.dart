import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../collections/spend_time_place.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';

import '../../utilities/utilities.dart';

class SameYearDaySpendPriceListAlert extends ConsumerStatefulWidget {
  const SameYearDaySpendPriceListAlert({super.key, required this.spendTimePlaceList});

  final List<SpendTimePlace> spendTimePlaceList;

  @override
  ConsumerState<SameYearDaySpendPriceListAlert> createState() => _SameYearDaySpendPriceListAlertState();
}

class _SameYearDaySpendPriceListAlertState extends ConsumerState<SameYearDaySpendPriceListAlert>
    with ControllersMixin<SameYearDaySpendPriceListAlert> {
  bool firstYearStartFromFirst = true;

  DateTime yearFirst = DateTime.now();

  List<String> youbiList = <String>['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  List<String> days = <String>[];

  final Utility _utility = Utility();

  final AutoScrollController autoScrollController = AutoScrollController();

  List<GlobalKey> globalKeyList = <GlobalKey<State<StatefulWidget>>>[];

  Map<String, String> _holidayMap = <String, String>{};

  int calendarYear = 2025;

  Map<String, int> yearShishutsuMap = <String, int>{};

  Map<String, int> yearShuunyuuMap = <String, int>{};

  Map<String, int> yearShuushiMap = <String, int>{};

  List<String> yearList = <String>[];

  String firstDate = '';

  String lastDate = '';

  ///
  @override
  void initState() {
    super.initState();

    // ignore: always_specify_types
    globalKeyList = List.generate(100, (int index) => GlobalKey());

    widget.spendTimePlaceList.sort((SpendTimePlace a, SpendTimePlace b) => a.date.compareTo(b.date));

    String keepDate = '';

    int sum = 0;
    int sum2 = 0;
    int sum3 = 0;

    for (final SpendTimePlace element in widget.spendTimePlaceList) {
      if (firstDate == '') {
        firstDate = element.date;
      }

      lastDate = element.date;

      if (element.date != keepDate) {
        sum = 0;
        sum2 = 0;
        sum3 = 0;
      }

      if (!yearList.contains(element.date.split('-')[0])) {
        yearList.add(element.date.split('-')[0]);
      }

      sum += element.price;

      yearShuushiMap[element.date] = sum;

      if (element.price > 0) {
        sum2 += element.price;

        yearShishutsuMap[element.date] = sum2;
      }

      if (element.price < 0) {
        sum3 += element.price;

        yearShuunyuuMap[element.date] = sum3;
      }

      keepDate = element.date;
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (calendarYear == DateTime.now().year) {
        final int diffDays = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
        final int index = (diffDays / 7).floor();

        final BuildContext target = globalKeyList[index].currentContext!;

        await Scrollable.ensureVisible(
          target,
          duration: const Duration(milliseconds: 1000),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DefaultTextStyle(
          style: GoogleFonts.kiwiMaru(fontSize: 12),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              SizedBox(width: context.screenSize.width),
              const Text('年別同日消費比較'),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              SizedBox(height: 300, child: _getCalendar()),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(child: displayYearDaySpendPriceList()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget displayYearDaySpendPriceList() {
    if (widget.spendTimePlaceList.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<Widget> list = <Widget>[];

    for (final String element in yearList) {
      if (element == firstDate.split('-')[0]) {
        int dispShishutsu = 0;
        makeYearDaysList(
          startDate: firstDate,
          endDate: '$element-${appParamState.sameYearDayCalendarSelectDate}',
        ).forEach((String element2) {
          if (yearShishutsuMap[element2] != null) {
            dispShishutsu += yearShishutsuMap[element2]!;
          }
        });

        int dispShuunyuu = 0;
        makeYearDaysList(
          startDate: firstDate,
          endDate: '$element-${appParamState.sameYearDayCalendarSelectDate}',
        ).forEach((String element2) {
          if (yearShuunyuuMap[element2] != null) {
            dispShuunyuu += yearShuunyuuMap[element2]!;
          }
        });

        int dispShuushi = 0;
        makeYearDaysList(
          startDate: firstDate,
          endDate: '$element-${appParamState.sameYearDayCalendarSelectDate}',
        ).forEach((String element2) {
          if (yearShuushiMap[element2] != null) {
            dispShuushi += yearShuushiMap[element2]!;
          }
        });

        list.add(
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(firstDate),
                          const Text(' - '),
                          Text('$element-${appParamState.sameYearDayCalendarSelectDate}'),
                        ],
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
                              child: DefaultTextStyle(
                                style: const TextStyle(color: Colors.yellowAccent, fontSize: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text('支出'),
                                    Text(
                                      (DateTime.parse(
                                                  '$element-${appParamState.sameYearDayCalendarSelectDate} 00:00:00')
                                              .isAfter(
                                        DateTime.now(),
                                      ))
                                          ? '-'
                                          : dispShishutsu.toString().toCurrency(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
                              child: DefaultTextStyle(
                                style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text('収入'),
                                    Text(
                                      (DateTime.parse(
                                                  '$element-${appParamState.sameYearDayCalendarSelectDate} 00:00:00')
                                              .isAfter(
                                        DateTime.now(),
                                      ))
                                          ? '-'
                                          : (dispShuunyuu * -1).toString().toCurrency(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
                              child: DefaultTextStyle(
                                style: const TextStyle(color: Colors.orangeAccent, fontSize: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text('収支'),
                                    Text(
                                      (DateTime.parse(
                                                  '$element-${appParamState.sameYearDayCalendarSelectDate} 00:00:00')
                                              .isAfter(
                                        DateTime.now(),
                                      ))
                                          ? '-'
                                          : (dispShuushi * -1).toString().toCurrency(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        int dispShishutsu = 0;
        makeYearDaysList(
          startDate: '$element-01-01',
          endDate: '$element-${appParamState.sameYearDayCalendarSelectDate}',
        ).forEach((String element2) {
          if (yearShishutsuMap[element2] != null) {
            dispShishutsu += yearShishutsuMap[element2]!;
          }
        });

        int dispShuunyuu = 0;
        makeYearDaysList(
          startDate: '$element-01-01',
          endDate: '$element-${appParamState.sameYearDayCalendarSelectDate}',
        ).forEach((String element2) {
          if (yearShuunyuuMap[element2] != null) {
            dispShuunyuu += yearShuunyuuMap[element2]!;
          }
        });

        int dispShuushi = 0;
        makeYearDaysList(
          startDate: '$element-01-01',
          endDate: '$element-${appParamState.sameYearDayCalendarSelectDate}',
        ).forEach((String element2) {
          if (yearShuushiMap[element2] != null) {
            dispShuushi += yearShuushiMap[element2]!;
          }
        });

        list.add(
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('$element-01-01'),
                          const Text(' - '),
                          Text('$element-${appParamState.sameYearDayCalendarSelectDate}'),
                        ],
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
                              child: DefaultTextStyle(
                                style: const TextStyle(color: Colors.yellowAccent, fontSize: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text('支出'),
                                    Text(
                                      (DateTime.parse(
                                                  '$element-${appParamState.sameYearDayCalendarSelectDate} 00:00:00')
                                              .isAfter(
                                        DateTime.now(),
                                      ))
                                          ? '-'
                                          : dispShishutsu.toString().toCurrency(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
                              child: DefaultTextStyle(
                                style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text('収入'),
                                    Text(
                                      (DateTime.parse(
                                                  '$element-${appParamState.sameYearDayCalendarSelectDate} 00:00:00')
                                              .isAfter(
                                        DateTime.now(),
                                      ))
                                          ? '-'
                                          : (dispShuunyuu * -1).toString().toCurrency(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
                              child: DefaultTextStyle(
                                style: const TextStyle(color: Colors.orangeAccent, fontSize: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text('収支'),
                                    Text(
                                      (DateTime.parse(
                                                  '$element-${appParamState.sameYearDayCalendarSelectDate} 00:00:00')
                                              .isAfter(
                                        DateTime.now(),
                                      ))
                                          ? '-'
                                          : (dispShuushi * -1).toString().toCurrency(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) => list[index], childCount: list.length),
        ),
      ],
    );
  }

  ///
  List<String> makeYearDaysList({required String startDate, required String endDate}) {
    final List<String> list = <String>[];

    for (DateTime date = DateTime.parse('$startDate 00:00:00');
        date.isBefore(DateTime.parse('$endDate 00:00:00').add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      final String formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      list.add(formattedDate);
    }

    return list;
  }

  ///
  Widget _getCalendar() {
    yearFirst = DateTime(calendarYear);

    final DateTime yearEnd = DateTime(yearFirst.year + 1, 1, 0);

    final int diff = yearEnd.difference(yearFirst).inDays;
    final int yearDaysNum = diff + 1;

    final String youbi = yearFirst.youbiStr;
    final int youbiNum = youbiList.indexWhere((String element) => element == youbi);

    final int weekNum = ((yearDaysNum + youbiNum) / 7).ceil();

    // ignore: always_specify_types
    days = List.generate(weekNum * 7, (int index) => '');

    for (int i = 0; i < (weekNum * 7); i++) {
      if (i >= youbiNum) {
        final DateTime gendate = yearFirst.add(Duration(days: i - youbiNum));

        if (yearFirst.year == gendate.year) {
          days[i] = gendate.mmdd;
        }
      }
    }

    final List<Widget> list = <Widget>[];
    for (int i = 0; i < weekNum; i++) {
      list.add(_getRow(days: days, rowNum: i));
    }

    return SingleChildScrollView(controller: autoScrollController, child: Column(children: list));
  }

  ///
  Widget _getRow({required List<String> days, required int rowNum}) {
    final List<Widget> list = <Widget>[];

    for (int i = rowNum * 7; i < ((rowNum + 1) * 7); i++) {
      final List<String> exDays = (days[i] == '') ? <String>[] : days[i].split('-');

      list.add(
        Expanded(
          child: (days[i] == '')
              ? Container()
              : GestureDetector(
                  onTap: () => appParamNotifier.setSameYearDayCalendarSelectDate(date: days[i]),
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(border: _getBorder(mmdd: days[i]), color: _getBgColor(mmdd: days[i])),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: BoxConstraints(minHeight: context.screenSize.height / 40),
                          child: Text(
                            (exDays[1] == '01') ? exDays[0] : days[i],
                            style: TextStyle(
                              fontSize: (exDays[1] == '01') ? 12 : 8,
                              color: (exDays[1] == '01') ? const Color(0xFFFBB6CE) : Colors.white,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[_dispRowNum(mmdd: days[i], rowNum: rowNum), const SizedBox.shrink()],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      );
    }

    return Row(key: globalKeyList[rowNum], crossAxisAlignment: CrossAxisAlignment.start, children: list);
  }

  ///
  Border _getBorder({required String mmdd}) {
    final DateTime genDate = DateTime.parse('$calendarYear-$mmdd');

    return (genDate.yyyymmdd == DateTime.now().yyyymmdd)
        ? Border.all(color: Colors.orangeAccent.withOpacity(0.4), width: 2)
        : Border.all(color: Colors.white.withOpacity(0.2), width: 2);
  }

  ///
  Color _getBgColor({required String mmdd}) {
    if (mmdd == '') {
      return Colors.transparent;
    }

    final DateTime genDate = DateTime.parse('$calendarYear-$mmdd');

    if (holidayState.holidayMap.value != null) {
      _holidayMap = holidayState.holidayMap.value!;
    }

    Color color = _utility.getYoubiColor(date: genDate.yyyymmdd, youbiStr: genDate.youbiStr, holidayMap: _holidayMap);

    if (mmdd == appParamState.sameYearDayCalendarSelectDate) {
      color = Colors.yellowAccent.withOpacity(0.2);
    }

    return color;
  }

  ///
  Widget _dispRowNum({required String mmdd, required int rowNum}) {
    final DateTime genDate = DateTime.parse('$calendarYear-$mmdd');

    return Text(
      (genDate.youbiStr == 'Sunday') ? (rowNum + 1).toString() : '',
      style: TextStyle(
        fontSize: 10,
        color: (genDate.youbiStr == 'Sunday') ? Colors.white.withOpacity(0.6) : Colors.transparent,
      ),
    );
  }
}
