// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../collections/spend_time_place.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';

import 'parts/money_dialog.dart';
import 'same_year_day_spend_price_list_alert.dart';

class SameDaySpendPriceListAlert extends ConsumerStatefulWidget {
  const SameDaySpendPriceListAlert({super.key, required this.isar, required this.spendTimePlaceList});

  final Isar isar;
  final List<SpendTimePlace> spendTimePlaceList;

  @override
  ConsumerState<SameDaySpendPriceListAlert> createState() => _SameDaySpendPriceListAlertState();
}

class _SameDaySpendPriceListAlertState extends ConsumerState<SameDaySpendPriceListAlert>
    with ControllersMixin<SameDaySpendPriceListAlert> {
  final ItemScrollController controller = ItemScrollController();
  final ItemPositionsListener listener = ItemPositionsListener.create();

  ///
  @override
  Widget build(BuildContext context) {
    if (appParamState.sameDaySelectedDay == DateTime.now().day) {
      WidgetsBinding.instance.addPostFrameCallback((_) async => controller.jumpTo(index: DateTime.now().day - 1));
    }

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
              const Text('同日消費比較'),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox.shrink(),
                  TextButton(
                      onPressed: () {
                        appParamNotifier.setSameYearDayCalendarSelectDate(date: DateTime.now().mmdd);

                        MoneyDialog(
                          context: context,
                          widget: SameYearDaySpendPriceListAlert(spendTimePlaceList: widget.spendTimePlaceList),
                        );
                      },
                      child: const Text('年別')),
                ],
              ),
              Expanded(
                child: SizedBox(
                  width: context.screenSize.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(child: _displaySameDaySpendPriceList()),
                      Container(width: 60, alignment: Alignment.topRight, child: _displayDayList()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayDayList() {
    final List<int> list = <int>[];

    for (int i = 1; i <= 31; i++) {
      list.add(i);
    }

    return ScrollablePositionedList.builder(
      itemCount: list.length,
      itemScrollController: controller,
      itemPositionsListener: listener,
      // ItemPositionsListenerでスクロールを監視
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: GestureDetector(
            onTap: () {
              appParamNotifier.setSameDaySelectedDay(day: index + 1);

              controller.jumpTo(index: index);
            },
            child: CircleAvatar(
              backgroundColor: ((appParamState.sameDaySelectedDay - 1) == index)
                  ? Colors.orangeAccent.withOpacity(0.3)
                  : Colors.black,
              child: Text((index + 1).toString(), style: const TextStyle(fontSize: 12, color: Colors.white)),
            ),
          ),
        );
      },
    );
  }

  ///
  Widget _displaySameDaySpendPriceList() {
    final List<Widget> list = <Widget>[];

    final Map<String, List<SpendTimePlace>> spendTimePlaceMap = <String, List<SpendTimePlace>>{};

    for (final SpendTimePlace element in widget.spendTimePlaceList) {
      final List<String> exDate = element.date.split('-');
      spendTimePlaceMap['${exDate[0]}-${exDate[1]}'] = <SpendTimePlace>[];
    }

    for (final SpendTimePlace element in widget.spendTimePlaceList) {
      final List<String> exDate = element.date.split('-');

      if (exDate[2].toInt() <= appParamState.sameDaySelectedDay) {
        spendTimePlaceMap['${exDate[0]}-${exDate[1]}']?.add(element);
      }
    }

    final Map<String, int> shishutsuPriceMap = <String, int>{};

    final Map<String, int> shuunyuuPriceMap = <String, int>{};

    final Map<String, int> shuushiPriceMap = <String, int>{};

    spendTimePlaceMap.forEach((String key, List<SpendTimePlace> value) {
      int sum = 0;
      int sum2 = 0;

      int sum3 = 0;

      for (final SpendTimePlace element in value) {
        sum += element.price;

        if (element.price > 0) {
          sum2 += element.price;
        }

        if (element.price < 0) {
          sum3 += element.price;
        }
      }

      shishutsuPriceMap[key] = sum2;

      shuunyuuPriceMap[key] = sum3;

      shuushiPriceMap[key] = sum;
    });

    shuushiPriceMap.forEach(
      (String key, int value) {
        final String shishutsu =
            (shishutsuPriceMap[key] != null) ? shishutsuPriceMap[key].toString().toCurrency() : 0.toString();

        final String shuunyuu = (shuunyuuPriceMap[key] != null)
            ? (shuunyuuPriceMap[key]! * -1).toString().toCurrency()
            : (0 * -1).toString();

        final String shuushi = (value * -1).toString().toCurrency();

        final int mark = ((value * -1) > 0)
            ? 1
            : (value == 0)
                ? 9
                : 0;

        list.add(
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
            child: Stack(
              children: <Widget>[
                Positioned(left: 0, bottom: 0, child: dispUpDownIcon(mark: mark)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: context.screenSize.width * 0.2, child: Text(key)),
                    const SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          DefaultTextStyle(
                            style: const TextStyle(color: Colors.yellowAccent, fontSize: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[const Text('支出'), Text(shishutsu)],
                              ),
                            ),
                          ),
                          DefaultTextStyle(
                            style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[const Text('収入'), Text(shuunyuu)],
                              ),
                            ),
                          ),
                          DefaultTextStyle(
                            style: const TextStyle(color: Colors.orangeAccent, fontSize: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[const Text('収支'), Text(shuushi)],
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
        );
      },
    );

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
  Widget dispUpDownIcon({required int mark}) {
    switch (mark) {
      case 1:
        return const Icon(Icons.arrow_upward, color: Colors.greenAccent);
      case 0:
        return const Icon(Icons.arrow_downward, color: Colors.redAccent);
      default:
        return const Icon(Icons.crop_square, color: Colors.black);
    }
  }
}
