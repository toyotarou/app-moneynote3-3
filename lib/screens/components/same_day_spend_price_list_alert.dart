import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/spend_time_place.dart';
import '../../extensions/extensions.dart';
import '../../state/app_params/app_params_notifier.dart';

class SameDaySpendPriceListAlert extends ConsumerStatefulWidget {
  const SameDaySpendPriceListAlert({super.key, required this.isar, required this.spendTimePlaceList});

  final Isar isar;
  final List<SpendTimePlace> spendTimePlaceList;

  @override
  ConsumerState<SameDaySpendPriceListAlert> createState() => _SameDaySpendPriceListAlertState();
}

class _SameDaySpendPriceListAlertState extends ConsumerState<SameDaySpendPriceListAlert> {
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
              Container(width: context.screenSize.width),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('同日消費比較'), Container()],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _displaySameDaySpendPriceList()),
                    Container(width: 60, alignment: Alignment.topRight, child: Expanded(child: _displayDayList())),
                  ],
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
    final list = <Widget>[];

    final sameDaySelectedDay = ref.watch(appParamProvider.select((value) => value.sameDaySelectedDay));

    for (var i = 1; i <= 31; i++) {
      list.add(Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: GestureDetector(
          onTap: () => ref.read(appParamProvider.notifier).setSameDaySelectedDay(day: i),
          child: CircleAvatar(
            backgroundColor: (sameDaySelectedDay == i) ? Colors.orangeAccent.withOpacity(0.3) : Colors.black,
            child: Text(i.toString(), style: const TextStyle(fontSize: 12, color: Colors.white)),
          ),
        ),
      ));
    }

    return SingleChildScrollView(child: Column(children: list));
  }

  ///
  Widget _displaySameDaySpendPriceList() {
    final sameDaySelectedDay = ref.watch(appParamProvider.select((value) => value.sameDaySelectedDay));

    final list = <Widget>[];

    final spendTimePlaceMap = <String, List<SpendTimePlace>>{};

    widget.spendTimePlaceList.forEach((element) {
      final exDate = element.date.split('-');
      spendTimePlaceMap['${exDate[0]}-${exDate[1]}'] = [];
    });

    widget.spendTimePlaceList.forEach((element) {
      final exDate = element.date.split('-');

      if (exDate[2].toInt() <= sameDaySelectedDay) {
        spendTimePlaceMap['${exDate[0]}-${exDate[1]}']?.add(element);
      }
    });

    final spendTimePlacePriceMap = <String, int>{};
    spendTimePlaceMap.forEach((key, value) {
      var sum = 0;
      value.forEach((element) => sum += element.price);

      spendTimePlacePriceMap[key] = sum;
    });

    spendTimePlacePriceMap.forEach((key, value) {
      list.add(Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(key), Text(value.toString().toCurrency())],
        ),
      ));
    });

    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: list));
  }
}
