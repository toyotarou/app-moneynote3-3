import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../collections/spend_time_place.dart';
import '../../extensions/extensions.dart';
import '../../repository/spend_time_places_repository.dart';

class SpendItemHistoryAlert extends StatefulWidget {
  const SpendItemHistoryAlert({
    super.key,
    required this.date,
    required this.item,
    required this.isar,
    required this.sum,
    required this.from,
  });

  final DateTime date;
  final String item;
  final Isar isar;
  final int sum;
  final String from;

  @override
  State<SpendItemHistoryAlert> createState() => _SpendItemHistoryAlertState();
}

class _SpendItemHistoryAlertState extends State<SpendItemHistoryAlert> {
  // ignore: use_late_for_private_fields_and_variables
  List<SpendTimePlace>? _spendItemPlaceHistoryList = <SpendTimePlace>[];

  ///
  void _init() {
    _makeSpendItemPlaceHistoryList();

    getInit = true;
  }

  bool getInit = false;

  ///
  @override
  Widget build(BuildContext context) {
    if (!getInit) {
      // ignore: always_specify_types
      Future(_init);
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
              Container(width: context.screenSize.width),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('使用用途履歴'),
                  Row(
                    children: <Widget>[
                      Text(widget.item),
                      if (widget.from == 'home_screen') ...<Widget>[
                        const SizedBox(width: 10),
                        Text(widget.sum.toString().toCurrency()),
                      ],
                    ],
                  ),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(child: _displaySpendItemPlaceHistoryList()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _makeSpendItemPlaceHistoryList() async {
    final Map<String, dynamic> param = <String, dynamic>{};
    param['item'] = widget.item;

    await SpendTimePlacesRepository()
        .getSpendTypeSpendTimePlaceList(isar: widget.isar, param: param)
        .then((List<SpendTimePlace>? value) =>
            setState(() => _spendItemPlaceHistoryList = value));
  }

  ///
  Widget _displaySpendItemPlaceHistoryList() {
    final List<Widget> list = <Widget>[];

    for (int i = 0; i < _spendItemPlaceHistoryList!.length; i++) {
      if (widget.from == 'home_screen') {
        if (widget.date.month !=
            DateTime.parse('${_spendItemPlaceHistoryList![i].date} 00:00:00')
                .month) {
          continue;
        }
      }

      list.add(Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(_spendItemPlaceHistoryList![i].date),
                const SizedBox(width: 10),
                Text(_spendItemPlaceHistoryList![i].time),
              ],
            ),
            Text(_spendItemPlaceHistoryList![i].price.toString().toCurrency()),
          ],
        ),
      ));
    }

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
