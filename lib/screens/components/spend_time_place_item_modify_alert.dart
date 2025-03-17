import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/spend_time_place.dart';

import '../../controllers/controllers_mixin.dart';
import '../../extensions/extensions.dart';
import '../../repository/spend_time_places_repository.dart';
import 'parts/error_dialog.dart';

class SpendTimePlaceItemModifyAlert extends ConsumerStatefulWidget {
  const SpendTimePlaceItemModifyAlert({super.key, required this.isar, required this.spendTimePlace});

  final Isar isar;
  final SpendTimePlace spendTimePlace;

  ///
  @override
  ConsumerState<SpendTimePlaceItemModifyAlert> createState() => _SpendTimePlaceItemModifyAlertState();
}

class _SpendTimePlaceItemModifyAlertState extends ConsumerState<SpendTimePlaceItemModifyAlert>
    with ControllersMixin<SpendTimePlaceItemModifyAlert> {
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
              const Text('消費アイテム修正'),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              displayTopPlate(),
              displayButtonColumn(),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget displayTopPlate() {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(blurRadius: 24, spreadRadius: 16, color: Colors.black.withOpacity(0.2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            width: context.screenSize.width,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('date'),
                      Text(widget.spendTimePlace.date),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('time'),
                      Text(widget.spendTimePlace.time),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('spendType'),
                      Text(widget.spendTimePlace.spendType),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('price'),
                      Text(widget.spendTimePlace.price.toString().toCurrency()),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('place'),
                      Text(widget.spendTimePlace.place),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget displayButtonColumn() {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('このレコードを削除する'),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                onPressed: _showDeleteDialog,
                child: const Text('削除'),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('このレコードの日付を変更する'),
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: _showDP,
                          child: Icon(
                            Icons.calendar_month,
                            color: Colors.greenAccent.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(spendTimePlacesControllerState.spendTimePlaceItemChangeDate),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                onPressed: () {
                  if (spendTimePlacesControllerState.spendTimePlaceItemChangeDate == '') {
                    // ignore: always_specify_types
                    Future.delayed(
                      Duration.zero,
                      () => error_dialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          title: '変更できません。',
                          content: '変更する日付を入力してください。'),
                    );

                    return;
                  }

                  _updateSpendTimePlaceItem();
                },
                child: const Text('変更'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///
  Future<void> _showDP() async {
    final DateTime? selectedDate = await showDatePicker(
      barrierColor: Colors.transparent,
      locale: const Locale('ja'),
      context: context,
      initialDate: DateTime.parse('${widget.spendTimePlace.date} 00:00:00'),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 360)),
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
      },
    );

    if (selectedDate != null) {
      spendTimePlacesNotifier.setSpendTimePlaceItemChangeDate(date: selectedDate.yyyymmdd);
    }
  }

  ///
  Future<void> _updateSpendTimePlaceItem() async {
    final SpendTimePlace spendTimePlaceItem = widget.spendTimePlace
      ..date = spendTimePlacesControllerState.spendTimePlaceItemChangeDate;

    await widget.isar.writeTxn(() async {
      // ignore: always_specify_types
      await SpendTimePlacesRepository()
          .updateSpendTimePlace(isar: widget.isar, spendTimePlace: spendTimePlaceItem)
          // ignore: always_specify_types
          .then((value) async {
        spendTimePlacesNotifier.setSpendTimePlaceItemChangeDate(date: '');

        if (mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        }
      });
    });
  }

  ///
  void _showDeleteDialog() {
    final Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text('いいえ'));

    final Widget continueButton = TextButton(
        onPressed: () {
          _deleteSpendTimePlaceItem();

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
  Future<void> _deleteSpendTimePlaceItem() async {
    // ignore: always_specify_types
    await SpendTimePlacesRepository()
        .deleteSpendTimePrice(isar: widget.isar, id: widget.spendTimePlace.id)
        // ignore: always_specify_types
        .then((value) {
      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);

        Navigator.pop(context);
      }
    });
  }
}
