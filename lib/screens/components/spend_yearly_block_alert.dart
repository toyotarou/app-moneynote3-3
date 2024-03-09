import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/spend_item.dart';
import '../../collections/spend_time_place.dart';
import '../../extensions/extensions.dart';
import '../../repository/spend_items_repository.dart';
import '../../repository/spend_time_places_repository.dart';
import '../../utilities/functions.dart';

class SpendYearlyBlockAlert extends ConsumerStatefulWidget {
  const SpendYearlyBlockAlert({super.key, required this.date, required this.isar});

  final DateTime date;
  final Isar isar;

  @override
  ConsumerState<SpendYearlyBlockAlert> createState() => _SpendYearlyBlockAlertState();
}

class _SpendYearlyBlockAlertState extends ConsumerState<SpendYearlyBlockAlert> {
  // ignore: use_late_for_private_fields_and_variables
  List<SpendTimePlace>? yearlySpendTimePlaceList = [];

  Map<String, List<int>> _yearlySpendSumMap = {};

  List<SpendItem>? _spendItemList = [];

  ///
  void _init() {
    _makeYearlySpendSumMap();

    _makeSpendItemList();
  }

  ///
  @override
  Widget build(BuildContext context) {
    Future(_init);

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('年間使用金額比較'), Text(widget.date.yyyy)],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(child: _displayYearlySpendSumMap()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _makeYearlySpendSumMap() async {
    final param = <String, dynamic>{};
    param['date'] = widget.date.yyyy;

    await SpendTimePlacesRepository().getDateSpendTimePlaceList(isar: widget.isar, param: param).then((value) {
      setState(() {
        yearlySpendTimePlaceList = value;

        if (value != null) {
          _yearlySpendSumMap = makeYearlySpendItemSumMap(spendItemList: _spendItemList, spendTimePlaceList: value);
        }
      });
    });
  }

  ///
  Widget _displayYearlySpendSumMap() {
    final list = <Widget>[];

    final spendItemColorMap = <String, String>{};
    if (_spendItemList!.isNotEmpty) {
      _spendItemList!.forEach((element) {
        spendItemColorMap[element.spendItemName] = element.color;
      });
    }

    final oneWidth = context.screenSize.width / 6;

    var allTotal = 0;
    _yearlySpendSumMap.forEach((key, value) {
      final list2 = <Widget>[];

      final map = <int, String>{};

      var sum = 0;

      value.forEach((element) {
        if (element > 0) {
          map[element] = '';

          sum += element;
        }
      });

      allTotal += sum;

      if (map.isNotEmpty) {
        final lineColor =
            (spendItemColorMap[key] != null && spendItemColorMap[key] != '') ? spendItemColorMap[key] : '0xffffffff';

        list.add(Container(
          width: context.screenSize.width,
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo.withOpacity(0.8), Colors.transparent],
              stops: const [0.7, 1],
            ),
          ),
          child: DefaultTextStyle(
            style: TextStyle(color: Color(lineColor!.toInt()), fontSize: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(key), Text(sum.toString().toCurrency())],
            ),
          ),
        ));

        var i = 1;
        value.forEach((element) {
          list2.add(
            Stack(
              children: [
                Container(
                  width: oneWidth,
                  padding: const EdgeInsets.all(2),
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(0.4))),
                  alignment: Alignment.topRight,
                  child: Text(
                    element.toString().toCurrency(),
                    style: TextStyle(color: (i == widget.date.month) ? Colors.yellowAccent : Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Text(i.toString().padLeft(2, '0'), style: const TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          );

          i++;
        });
      }

      list.add(Wrap(children: list2));
    });

    list
      ..add(const SizedBox(height: 20))
      ..add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(color: Colors.yellowAccent.withOpacity(0.1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Text(allTotal.toString().toCurrency(), style: const TextStyle(color: Colors.yellowAccent)),
            ],
          ),
        ),
      )
      ..add(const SizedBox(height: 20));

    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: list));
  }

  ///
  Future<void> _makeSpendItemList() async {
    await SpendItemsRepository().getSpendItemList(isar: widget.isar).then((value) {
      setState(() => _spendItemList = value);
    });
  }
}
