import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../collections/spend_time_place.dart';
import '../../extensions/extensions.dart';
import '../../state/holidays/holidays_notifier.dart';
import '../../state/holidays/holidays_response_state.dart';
import '../../utilities/utilities.dart';

class SameYearDaySpendPriceListAlert extends ConsumerStatefulWidget {
  const SameYearDaySpendPriceListAlert({super.key, required this.spendTimePlaceList});

  final List<SpendTimePlace> spendTimePlaceList;

  @override
  ConsumerState<SameYearDaySpendPriceListAlert> createState() => _SameYearDaySpendPriceListAlertState();
}

class _SameYearDaySpendPriceListAlertState extends ConsumerState<SameYearDaySpendPriceListAlert> {
  bool firstYearStartFromFirst = true;

  DateTime yearFirst = DateTime.now();

  List<String> youbiList = <String>['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  List<String> days = <String>[];

  final Utility _utility = Utility();

  final AutoScrollController autoScrollController = AutoScrollController();

  List<GlobalKey> globalKeyList = <GlobalKey<State<StatefulWidget>>>[];

  Map<String, String> _holidayMap = <String, String>{};

  int calendarYear = 2025;

  ///
  @override
  void initState() {
    super.initState();

    // ignore: always_specify_types
    globalKeyList = List.generate(100, (int index) => GlobalKey());
  }

  ///
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (calendarYear == DateTime.now().year) {
        final diffDays = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
        final index = (diffDays / 7).floor();

        final target = globalKeyList[index].currentContext!;

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

              // Expanded(child: displayYearDaySpendPriceList()),
              //
              //
              //
              //
              //
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

    widget.spendTimePlaceList.sort((SpendTimePlace a, SpendTimePlace b) => a.date.compareTo(b.date));

    final Map<int, List<String>> yearsDateListMap = makeYearsDateListMap();

    final Map<int, Map<String, int>> yearDatePriceMap = makeYearDatePriceMap(yearsDateListMap: yearsDateListMap);

    yearDatePriceMap.forEach((int key, Map<String, int> value) {
      print('$key / ${value.length}');
      print('$key / ${value['$key-01-01']}');
    });

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
  Map<int, Map<String, int>> makeYearDatePriceMap({required Map<int, List<String>> yearsDateListMap}) {
    final Map<int, Map<String, int>> map = <int, Map<String, int>>{};

    yearsDateListMap.forEach((int key, List<String> value) {
      final Map<String, int> map2 = <String, int>{};

      for (final String element in value) {
        int price = 0;
        for (final SpendTimePlace element2 in widget.spendTimePlaceList) {
          if (element == element2.date) {
            price += element2.price;
          }
        }

        map2[element] = price;
      }

      map[key] = map2;
    });

    return map;
  }

  ///
  Map<int, List<String>> makeYearsDateListMap() {
    final Map<int, List<String>> map = <int, List<String>>{};

    final String firstDate = widget.spendTimePlaceList.first.date;

    final List<String> exFirstDate = firstDate.split('-');

    // ignore: literal_only_boolean_expressions
    if ('01-01' != '${exFirstDate[1]}-${exFirstDate[2]}') {
      firstYearStartFromFirst = false;
    }

    final String firstYear = exFirstDate[0];

    final String lastDate = widget.spendTimePlaceList.last.date;

    final List<String> exLastDate = lastDate.split('-');

    final String lastYear = exLastDate[0];

    if (firstYear == lastYear) {
      map[firstYear.toInt()] = makeYearDaysList(firstDate: firstDate, lastDate: lastDate);
    } else {
      for (int i = firstYear.toInt(); i <= lastYear.toInt(); i++) {
        if (i == firstYear.toInt()) {
          map[firstYear.toInt()] = makeYearDaysList(firstDate: firstDate, lastDate: DateTime(i + 1).yyyymmdd);
        } else if (i == lastYear.toInt()) {
          map[lastYear.toInt()] = makeYearDaysList(firstDate: DateTime(i).yyyymmdd, lastDate: DateTime.now().yyyymmdd);
        } else {
          map[i] = makeYearDaysList(firstDate: DateTime(i).yyyymmdd, lastDate: DateTime(i + 1).yyyymmdd);
        }
      }
    }

    return map;
  }

  ///
  List<String> makeYearDaysList({required String firstDate, required String lastDate}) {
    final List<String> list = <String>[];

    for (DateTime date = DateTime.parse('$firstDate 00:00:00');
        date.isBefore(DateTime.parse('$lastDate 00:00:00').add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      final String formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      if (firstDate.split('-')[0].toInt() == date.year) {
        list.add(formattedDate);
      }
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
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      border: _getBorder(mmdd: days[i]),
                      color: _getBgColor(mmdd: days[i]),
                    ),
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
                          children: <Widget>[
                            _dispRowNum(mmdd: days[i], rowNum: rowNum),
                            const SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      );
    }

    return Row(
      key: globalKeyList[rowNum],
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    );
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

    final HolidaysResponseState holidayState = ref.watch(holidayProvider);

    if (holidayState.holidayMap.value != null) {
      _holidayMap = holidayState.holidayMap.value!;
    }

    return _utility.getYoubiColor(date: genDate.yyyymmdd, youbiStr: genDate.youbiStr, holidayMap: _holidayMap);
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
