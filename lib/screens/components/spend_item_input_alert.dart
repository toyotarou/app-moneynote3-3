import 'dart:ui';

import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../collections/spend_item.dart';
import '../../collections/spend_time_place.dart';
import '../../extensions/extensions.dart';
import '../../repository/spend_items_repository.dart';
import 'parts/error_dialog.dart';
import 'parts/spend_item_card.dart';

class SpendItemInputAlert extends ConsumerStatefulWidget {
  const SpendItemInputAlert(
      {super.key, required this.isar, required this.spendItemList, required this.spendTimePlaceCountMap});

  final Isar isar;

  final List<SpendItem> spendItemList;

  final Map<String, List<SpendTimePlace>> spendTimePlaceCountMap;

  @override
  ConsumerState<SpendItemInputAlert> createState() => _SpendItemInputAlertState();
}

class _SpendItemInputAlertState extends ConsumerState<SpendItemInputAlert> {
  final TextEditingController _spendItemEditingController = TextEditingController();

  List<DragAndDropItem> spendItemDDItemList = [];
  List<DragAndDropList> ddList = [];

  List<int> orderedIdList = [];

  Color mycolor = Colors.white;

  Map<int, String> spendItemColorMap = {};

  Map<int, String> spendItemDefaultTimeMap = {};

  Map<int, String> spendItemNameMap = {};

  ///
  @override
  void initState() {
    super.initState();

    widget.spendItemList.forEach((element) {
      final colorCode = (element.color != '') ? element.color : '0xffffffff';
      final defaultTime = (element.defaultTime != '') ? element.defaultTime : '08:00';

      spendItemDDItemList.add(
        DragAndDropItem(
          child: SpendItemCard(
            key: Key(element.id.toString()),
            spendItemName: element.spendItemName,
            deleteButtonPress: () => _showDeleteDialog(id: element.id),
            colorPickerButtonPress: () => _showColorPickerDialog(id: element.id),
            colorCode: colorCode,
            defaultTimeButtonPress: () => _showDefaultTimeDialog(id: element.id),
            defaultTime: defaultTime,
            spendTimePlaceCountMap: widget.spendTimePlaceCountMap,
            isar: widget.isar,
          ),
        ),
      );

      spendItemColorMap[element.id] = element.color;

      spendItemDefaultTimeMap[element.id] = element.defaultTime;

      spendItemNameMap[element.id] = element.spendItemName;
    });

    ddList.add(DragAndDropList(children: spendItemDDItemList));
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: DefaultTextStyle(
            style: GoogleFonts.kiwiMaru(fontSize: 12),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(width: context.screenSize.width),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('消費アイテム管理'), Container()],
                ),
                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                _displayInputParts(),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          GestureDetector(
                            onTap: _inputSpendItem,
                            child: Text(
                              '消費アイテムを追加する',
                              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          GestureDetector(
                            onTap: _settingReorderIds,
                            child: Text(
                              '並び順を保存する',
                              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: DragAndDropLists(
                      children: ddList,
                      onItemReorder: _itemReorder,
                      onListReorder: _listReorder,

                      ///
                      itemDecorationWhileDragging: const BoxDecoration(
                        color: Colors.black,
                        boxShadow: [BoxShadow(color: Colors.white, blurRadius: 4)],
                      ),

                      ///
                      lastListTargetSize: 0,
                    ),
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
  Widget _displayInputParts() {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(blurRadius: 24, spreadRadius: 16, color: Colors.black.withOpacity(0.2))],
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
            child: TextField(
              controller: _spendItemEditingController,
              decoration: const InputDecoration(labelText: '消費アイテム'),
              style: const TextStyle(fontSize: 13, color: Colors.white),
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
            ),
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _inputSpendItem() async {
    if (_spendItemEditingController.text == '') {
      Future.delayed(
        Duration.zero,
        () => error_dialog(context: context, title: '登録できません。', content: '値を正しく入力してください。'),
      );

      return;
    }

    final spendItem = SpendItem()
      ..spendItemName = _spendItemEditingController.text
      ..order = widget.spendItemList.length + 1
      ..defaultTime = '08:00'
      ..color = '0xffffffff';

    await SpendItemsRepository().inputSpendItem(isar: widget.isar, spendItem: spendItem).then((value) {
      _spendItemEditingController.clear();
      Navigator.pop(context);
    });
  }

  ///
  void _itemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      final movedItem = ddList[oldListIndex].children.removeAt(oldItemIndex);

      ddList[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  ///
  void _listReorder(int oldListIndex, int newListIndex) {}

  ///
  void _showDeleteDialog({required int id}) {
    final Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text('いいえ'));

    final Widget continueButton = TextButton(
        onPressed: () {
          _deleteSpendItem(id: id);

          Navigator.pop(context);
        },
        child: const Text('はい'));

    final alert = AlertDialog(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      content: const Text('このデータを消去しますか？'),
      actions: [cancelButton, continueButton],
    );

    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  // ///
  // Future<void> _deleteSpendItem({required int id}) async {
  //   await SpendItemsRepository().getSpendItem(isar: widget.isar, id: id).then((value) {
  //     final param = <String, dynamic>{};
  //     param['item'] = value!.spendItemName;
  //
  //     SpendTimePlacesRepository().getSpendTypeSpendTimePlaceList(isar: widget.isar, param: param).then((value2) {
  //       final spendTimePriceList = <SpendTimePlace>[];
  //       value2!.forEach((element) => spendTimePriceList.add(element..spendType = ''));
  //
  //       SpendTimePlacesRepository()
  //           .updateSpendTimePriceList(isar: widget.isar, spendTimePriceList: spendTimePriceList)
  //           .then((value3) => SpendItemsRepository()
  //               .deleteSpendItem(isar: widget.isar, id: id)
  //               .then((value4) => Navigator.pop(context)));
  //     });
  //   });
  // }

  ///
  Future<void> _deleteSpendItem({required int id}) async {
    final spendItemsCollection = widget.isar.spendItems; //TODO

    //-----------------------------------

    final getSpendItem = await spendItemsCollection.filter().idEqualTo(id).findFirst();

    if (getSpendItem != null) {
      final spendTimePlacesCollection = widget.isar.spendTimePlaces;

      final getSpendTimePlaces =
          await spendTimePlacesCollection.filter().spendTypeEqualTo(getSpendItem.spendItemName).findAll();

      await widget.isar.writeTxn(() async {
        getSpendTimePlaces.forEach((element) async {
          final spendTimePlace = element
            ..date = element.date
            ..time = element.time
            ..price = element.price
            ..place = element.place
            ..spendType = '';

          await widget.isar.spendTimePlaces.put(spendTimePlace);
        });
      });
    }

    //-----------------------------------

    await widget.isar.writeTxn(() async => spendItemsCollection.delete(id));

    if (mounted) {
      Navigator.pop(context);
    }
  }

  // ///
  // Future<void> _settingReorderIds() async {
  //   orderedIdList = [];
  //
  //   for (final value in ddList) {
  //     for (final child in value.children) {
  //       orderedIdList.add(child.child.key
  //           .toString()
  //           .replaceAll('[', '')
  //           .replaceAll('<', '')
  //           .replaceAll("'", '')
  //           .replaceAll('>', '')
  //           .replaceAll(']', '')
  //           .toInt());
  //     }
  //   }
  //
  //   await widget.isar.writeTxn(() async {
  //     for (var i = 0; i < orderedIdList.length; i++) {
  //       await SpendItemsRepository().getSpendItem(isar: widget.isar, id: orderedIdList[i]).then((value) {
  //         value!.order = i;
  //
  //         SpendItemsRepository()
  //             .updateSpendItem(isar: widget.isar, spendItem: value)
  //             .then((value) => Navigator.pop(context));
  //       });
  //     }
  //   });
  // }

  ///
  Future<void> _settingReorderIds() async {
    orderedIdList = [];

    for (final value in ddList) {
      for (final child in value.children) {
        orderedIdList.add(child.child.key
            .toString()
            .replaceAll('[', '')
            .replaceAll('<', '')
            .replaceAll("'", '')
            .replaceAll('>', '')
            .replaceAll(']', '')
            .toInt());
      }
    }

    final spendItemsCollection = widget.isar.spendItems;

    await widget.isar.writeTxn(() async {
      for (var i = 0; i < orderedIdList.length; i++) {
        final getSpendItem = await spendItemsCollection.filter().idEqualTo(orderedIdList[i]).findFirst();
        if (getSpendItem != null) {
          getSpendItem
            ..spendItemName = spendItemNameMap[orderedIdList[i]].toString()
            ..order = i;

          await widget.isar.spendItems.put(getSpendItem);
        }
      }
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  ///
  void _showColorPickerDialog({required int id}) {
    if (spendItemColorMap[id] != null && spendItemColorMap[id] != '') {
      mycolor = Color(spendItemColorMap[id]!.toInt());
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey.withOpacity(0.3),
          title: const Text('Pick a color!', style: TextStyle(fontSize: 12)),
          content: BlockPicker(
            availableColors: const [
              Colors.white,
              Colors.pinkAccent,
              Colors.redAccent,
              Colors.deepOrangeAccent,
              Colors.orangeAccent,
              Colors.amberAccent,
              Colors.yellowAccent,
              Colors.lightGreenAccent,
              Colors.greenAccent,
              Colors.tealAccent,
              Colors.cyanAccent,
              Colors.lightBlueAccent,
              Colors.purpleAccent,
              Color(0xFFFBB6CE),
              Colors.grey,
            ],
            pickerColor: mycolor,
            onColorChanged: (Color color) async {
              mycolor = color;

              final exColor = color.toString().split(' ');
              var colorCode = '';
              if (exColor.length == 3) {
                colorCode = exColor[2].replaceAll('Color(', '').replaceAll(')', '');
              } else {
                colorCode = exColor[0].replaceAll('Color(', '').replaceAll(')', '');
              }

              await _updateColorCode(id: id, color: colorCode).then((value) {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            },
          ),
        );
      },
    );
  }

  ///
  Future<void> _showDefaultTimeDialog({required int id}) async {
    final initialHour = (spendItemDefaultTimeMap[id] != null && spendItemDefaultTimeMap[id] != '')
        ? spendItemDefaultTimeMap[id]!.split(':')[0].toInt()
        : 8;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: 0),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container(),
        );
      },
    );

    if (selectedTime != null) {
      final time = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';

      await _updateDefaultTime(id: id, time: time).then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }
  }

  ///
  Future<void> _updateColorCode({required int id, required String color}) async {
    await widget.isar.writeTxn(() async {
      await SpendItemsRepository().getSpendItem(isar: widget.isar, id: id).then((value) async {
        value!.color = color;

        await SpendItemsRepository().updateSpendItem(isar: widget.isar, spendItem: value);
      });
    });
  }

  ///
  Future<void> _updateDefaultTime({required int id, required String time}) async {
    await widget.isar.writeTxn(() async {
      await SpendItemsRepository().getSpendItem(isar: widget.isar, id: id).then((value) async {
        value!.defaultTime = time;

        await SpendItemsRepository().updateSpendItem(isar: widget.isar, spendItem: value);
      });
    });
  }
}
