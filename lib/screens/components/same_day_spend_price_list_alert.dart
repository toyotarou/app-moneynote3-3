// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../collections/spend_time_place.dart';
import '../../extensions/extensions.dart';
import '../../state/app_params/app_params_notifier.dart';
import '../../state/app_params/app_params_response_state.dart';

class SameDaySpendPriceListAlert extends ConsumerStatefulWidget {
  const SameDaySpendPriceListAlert(
      {super.key, required this.isar, required this.spendTimePlaceList});

  final Isar isar;
  final List<SpendTimePlace> spendTimePlaceList;

  @override
  ConsumerState<SameDaySpendPriceListAlert> createState() =>
      _SameDaySpendPriceListAlertState();
}

class _SameDaySpendPriceListAlertState
    extends ConsumerState<SameDaySpendPriceListAlert> {
  final ItemScrollController controller = ItemScrollController();
  final ItemPositionsListener listener = ItemPositionsListener.create();

  ///
  @override
  Widget build(BuildContext context) {
    final int sameDaySelectedDay = ref.watch(appParamProvider
        .select((AppParamsResponseState value) => value.sameDaySelectedDay));

    if (sameDaySelectedDay == DateTime.now().day) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) async => controller.jumpTo(index: DateTime.now().day - 1));
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
              Expanded(
                child: SizedBox(
                  width: context.screenSize.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(child: _displaySameDaySpendPriceList()),
                      Container(
                        width: 60,
                        alignment: Alignment.topRight,
                        child: _displayDayList(),
                      ),
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
    final int sameDaySelectedDay = ref.watch(appParamProvider
        .select((AppParamsResponseState value) => value.sameDaySelectedDay));

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
              ref
                  .read(appParamProvider.notifier)
                  .setSameDaySelectedDay(day: index + 1);

              controller.jumpTo(index: index);
            },
            child: CircleAvatar(
              backgroundColor: ((sameDaySelectedDay - 1) == index)
                  ? Colors.orangeAccent.withOpacity(0.3)
                  : Colors.black,
              child: Text((index + 1).toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.white)),
            ),
          ),
        );
      },
    );
  }

  ///
  Widget _displaySameDaySpendPriceList() {
    final int sameDaySelectedDay = ref.watch(appParamProvider
        .select((AppParamsResponseState value) => value.sameDaySelectedDay));

    final List<Widget> list = <Widget>[];

    final Map<String, List<SpendTimePlace>> spendTimePlaceMap =
        <String, List<SpendTimePlace>>{};

    for (final SpendTimePlace element in widget.spendTimePlaceList) {
      final List<String> exDate = element.date.split('-');
      spendTimePlaceMap['${exDate[0]}-${exDate[1]}'] = <SpendTimePlace>[];
    }

    for (final SpendTimePlace element in widget.spendTimePlaceList) {
      final List<String> exDate = element.date.split('-');

      if (exDate[2].toInt() <= sameDaySelectedDay) {
        spendTimePlaceMap['${exDate[0]}-${exDate[1]}']?.add(element);
      }
    }

    final Map<String, int> spendTimePlacePriceMap = <String, int>{};

    final Map<String, int> eachMonthMinusPriceMap = <String, int>{};

    spendTimePlaceMap.forEach((String key, List<SpendTimePlace> value) {
      int sum = 0;
      int sum2 = 0;
      for (final SpendTimePlace element in value) {
        sum += element.price;

        if (element.price > 0) {
          sum2 += element.price;
        }
      }

      spendTimePlacePriceMap[key] = sum;

      eachMonthMinusPriceMap[key] = sum2;
    });

    spendTimePlacePriceMap.forEach((String key, int value) {
      list.add(Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(key),
                Text(value.toString().toCurrency()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const SizedBox(),
                Text(
                  (eachMonthMinusPriceMap[key] != null)
                      ? eachMonthMinusPriceMap[key].toString().toCurrency()
                      : 0.toString(),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ));
    });

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => list[index],
            childCount: list.length,
          ),
        ),
      ],
    );
  }
}
