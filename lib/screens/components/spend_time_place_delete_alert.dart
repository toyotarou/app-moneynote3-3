import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';

import '../../collections/spend_time_place.dart';
import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../repository/spend_time_places_repository.dart';
import '../home_screen.dart';

class SpendTimePlaceDeleteAlert extends ConsumerStatefulWidget {
  const SpendTimePlaceDeleteAlert({super.key, required this.isar, this.allSpendTimePlaceList, required this.date});

  final DateTime date;
  final Isar isar;
  final List<SpendTimePlace>? allSpendTimePlaceList;

  @override
  ConsumerState<SpendTimePlaceDeleteAlert> createState() => _SpendTimePlaceDeleteAlertState();
}

class _SpendTimePlaceDeleteAlertState extends ConsumerState<SpendTimePlaceDeleteAlert>
    with ControllersMixin<SpendTimePlaceDeleteAlert> {
  ///
  @override
  Widget build(BuildContext context) {
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
                  const Text('詳細データ削除'),
                  Row(
                    children: <Widget>[
                      IconButton(onPressed: () => _showDP(), icon: const Icon(Icons.calendar_month)),
                      SizedBox(
                        width: 100,
                        child: Text(appParamState.deleteSpendTimePlaceDate),
                      )
                    ],
                  )
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(child: displaySpendTimePlaceList()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _showDP() async {
    final DateTime? selectedDate = await showDatePicker(
        barrierColor: Colors.transparent,
        locale: const Locale('ja'),
        context: context,
        firstDate: DateTime(DateTime.now().year - 2),
        lastDate: DateTime(DateTime.now().year + 3),
        initialDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.black.withOpacity(0.1),
              canvasColor: Colors.black.withOpacity(0.1),
              cardColor: Colors.black.withOpacity(0.1),
              dividerColor: Colors.indigo,
              primaryColor: Colors.black.withOpacity(0.1),
              secondaryHeaderColor: Colors.black.withOpacity(0.1),
              dialogBackgroundColor: Colors.black.withOpacity(0.1),
              primaryColorDark: Colors.black.withOpacity(0.1),
              highlightColor: Colors.black.withOpacity(0.1),
            ),
            child: child!,
          );
        });

    if (selectedDate != null) {
      appParamNotifier.setDeleteSpendTimePlaceDate(date: selectedDate.yyyymmdd);
    }
  }

  ///
  Widget displaySpendTimePlaceList() {
    final List<Widget> list = <Widget>[];

    if (appParamState.deleteSpendTimePlaceDate != '') {
      widget.allSpendTimePlaceList
        ?..sort((SpendTimePlace a, SpendTimePlace b) => a.time.compareTo(b.time))
        ..forEach((SpendTimePlace element) {
          if (element.date == appParamState.deleteSpendTimePlaceDate) {
            list.add(Container(
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Text(element.spendType), Text(element.time)],
                  ),
                  Row(
                    children: <Widget>[
                      Text(element.price.toString().toCurrency()),
                      IconButton(
                          onPressed: () => _showDeleteDialog(element: element),
                          icon: Icon(Icons.delete, color: Colors.white.withValues(alpha: 0.4))),
                    ],
                  ),
                ],
              ),
            ));
          }
        });
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

  ///
  void _showDeleteDialog({required SpendTimePlace element}) {
    final Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text('いいえ'));

    final Widget continueButton = TextButton(
        onPressed: () {
          _deleteSpendTimePlaceData(element: element);

          Navigator.pop(context);
        },
        child: const Text('はい'));

    final AlertDialog alert = AlertDialog(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      content: const Text('このデータを消去しますか？'),
      actions: <Widget>[cancelButton, continueButton],
    );

    // ignore: inference_failure_on_function_invocation
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  ///
  Future<void> _deleteSpendTimePlaceData({required SpendTimePlace element}) async {
    // ignore: always_specify_types
    SpendTimePlacesRepository().deleteSpendTimePrice(isar: widget.isar, id: element.id).then((value) {
      if (mounted) {
        Navigator.pop(context);

        Navigator.pop(context);

        Navigator.pushReplacement(
          context,
          // ignore: inference_failure_on_instance_creation, always_specify_types
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(isar: widget.isar, baseYm: widget.date.yyyymm),
          ),
        );
      }
    });
  }
}
