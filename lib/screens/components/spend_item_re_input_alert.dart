// ignore_for_file: depend_on_referenced_packages

import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/spend_item.dart';
import '../../collections/spend_time_place.dart';
import '../../extensions/extensions.dart';
import '../../state/app_params/app_params_notifier.dart';
import 'parts/error_dialog.dart';

class SpendItemReInputAlert extends ConsumerStatefulWidget {
  const SpendItemReInputAlert(
      {super.key,
      required this.isar,
      required this.spendTypeBlankSpendTimePlaceList,
      required this.spendItemList});

  final Isar isar;
  final List<SpendItem> spendItemList;
  final List<SpendTimePlace> spendTypeBlankSpendTimePlaceList;

  @override
  ConsumerState<SpendItemReInputAlert> createState() =>
      _SpendItemReInputAlertState();
}

class _SpendItemReInputAlertState extends ConsumerState<SpendItemReInputAlert> {
  Map<int, String> reinputSpendNameMap = {};

  ///
  @override
  Widget build(BuildContext context) {
    final inputButtonClicked =
        ref.watch(appParamProvider.select((value) => value.inputButtonClicked));

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
                children: [
                  const Text('消費アイテム再設定'),
                  ElevatedButton(
                    onPressed: inputButtonClicked
                        ? null
                        : () {
                            ref
                                .read(appParamProvider.notifier)
                                .setInputButtonClicked(flag: true);

                            _updateSpendName();
                          },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent.withOpacity(0.2)),
                    child: const Text('input'),
                  ),
                ],
              ),
              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              Expanded(child: _displayInputParts()),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _displayInputParts() {
    final list = <Widget>[];

    final spendItemList = <SpendItem>[
      SpendItem()
        ..id = 9999
        ..spendItemName = ''
        ..order = 9999
        ..defaultTime = '08:00'
        ..color = ''
    ];

    widget.spendItemList.forEach(spendItemList.add);

    widget.spendTypeBlankSpendTimePlaceList.mapIndexed((index, element) {
      list.add(DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurRadius: 24,
                spreadRadius: 16,
                color: Colors.black.withOpacity(0.2))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Stack(
              children: [
                Positioned(
                  bottom: 5,
                  right: 15,
                  child: Text(
                    (index + 1).toString().padLeft(2, '0'),
                    style: TextStyle(
                        fontSize: 60, color: Colors.grey.withOpacity(0.3)),
                  ),
                ),
                Container(
                  width: context.screenSize.width,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.2), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: DropdownButton(
                            isExpanded: true,
                            dropdownColor: Colors.pinkAccent.withOpacity(0.1),
                            iconEnabledColor: Colors.white,
                            items: spendItemList.map((e) {
                              return DropdownMenuItem(
                                value: e.spendItemName,
                                child: Text(e.spendItemName,
                                    style: const TextStyle(fontSize: 12)),
                              );
                            }).toList(),
                            value: reinputSpendNameMap[element.id] ?? '',
                            onChanged: (value) => addToReinputSpendNameMap(
                                id: element.id, value: value),
                          )),
                          SizedBox(
                            width: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(element.date),
                                Text(element.time),
                                Text(element.price.toString().toCurrency()),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(width: 10),
                          Text(element.place)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    });

    /*
    var i = 0;
    widget.spendTypeBlankSpendTimePlaceList.forEach((element) {
      list.add(DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 24, spreadRadius: 16, color: Colors.black.withOpacity(0.2))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Stack(
              children: [
                Positioned(
                  bottom: 5,
                  right: 15,
                  child: Text(
                    (i + 1).toString().padLeft(2, '0'),
                    style: TextStyle(fontSize: 60, color: Colors.grey.withOpacity(0.3)),
                  ),
                ),
                Container(
                  width: context.screenSize.width,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: DropdownButton(
                            isExpanded: true,
                            dropdownColor: Colors.pinkAccent.withOpacity(0.1),
                            iconEnabledColor: Colors.white,
                            items: spendItemList.map((e) {
                              return DropdownMenuItem(
                                value: e.spendItemName,
                                child: Text(e.spendItemName, style: const TextStyle(fontSize: 12)),
                              );
                            }).toList(),
                            value: reinputSpendNameMap[element.id] ?? '',
                            onChanged: (value) => addToReinputSpendNameMap(id: element.id, value: value),
                          )),
                          SizedBox(
                            width: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(element.date),
                                Text(element.time),
                                Text(element.price.toString().toCurrency()),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [const Icon(Icons.location_on), const SizedBox(width: 10), Text(element.place)],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ));

      i++;
    });
*/

    return SingleChildScrollView(child: Column(children: list));
  }

  ///
  void addToReinputSpendNameMap({required Id id, String? value}) {
    if (value != null) {
      reinputSpendNameMap[id] = value;

      setState(() {});
    }
  }

  // ///
  // Future<void> _updateSpendName() async {
  //   if (reinputSpendNameMap.isEmpty) {
  //     Future.delayed(
  //       Duration.zero,
  //       () => error_dialog(context: context, title: '登録できません。', content: '値を正しく入力してください。'),
  //     );
  //
  //     await ref.read(appParamProvider.notifier).setInputButtonClicked(flag: false);
  //
  //     return;
  //   }
  //
  //   await widget.isar.writeTxn(() async {
  //     await SpendTimePlacesRepository()
  //         .updateSpendTimePriceList(isar: widget.isar, spendTimePriceList: widget.spendTypeBlankSpendTimePlaceList)
  //         .then((value) {
  //       Navigator.pop(context);
  //       Navigator.pop(context);
  //     });
  //   });
  // }

  ///
  Future<void> _updateSpendName() async {
    if (reinputSpendNameMap.isEmpty) {
      Future.delayed(
        Duration.zero,
        () => error_dialog(
            context: context, title: '登録できません。', content: '値を正しく入力してください。'),
      );

      await ref
          .read(appParamProvider.notifier)
          .setInputButtonClicked(flag: false);

      return;
    }

    await widget.isar.writeTxn(() async {
      // ignore: avoid_function_literals_in_foreach_calls
      widget.spendTypeBlankSpendTimePlaceList.forEach((element) async {
        final spendTimePlace = element
          ..spendType = reinputSpendNameMap[element.id]!;
        await widget.isar.spendTimePlaces.put(spendTimePlace);
      });
    });

    if (mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }
}
