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
import '../../utilities/functions.dart';
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

  List<DragAndDropItem> spendItemDDItemList = <DragAndDropItem>[];
  List<DragAndDropList> ddList = <DragAndDropList>[];

  List<int> orderedIdList = <int>[];

  Color mycolor = Colors.white;

  Map<int, String> spendItemColorMap = <int, String>{};

  Map<int, String> spendItemDefaultTimeMap = <int, String>{};

  Map<int, String> spendItemNameMap = <int, String>{};

  List<FocusNode> focusNodeList = <FocusNode>[];

  ///
  @override
  void initState() {
    super.initState();

    for (final SpendItem element in widget.spendItemList) {
      final String colorCode = (element.color != '') ? element.color : '0xffffffff';
      final String defaultTime = (element.defaultTime != '') ? element.defaultTime : '08:00';

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
    }

    ddList.add(DragAndDropList(children: spendItemDDItemList));

    // ignore: always_specify_types
    focusNodeList = List.generate(100, (int index) => FocusNode());
  }

  ///
  @override
  void dispose() {
    _spendItemEditingController.dispose();

    super.dispose();
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
              children: <Widget>[
                const SizedBox(height: 20),
                Container(width: context.screenSize.width),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('消費アイテム管理'), SizedBox.shrink()],
                ),
                Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
                _displayInputParts(),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox.shrink(),
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
                        children: <Widget>[
                          const SizedBox.shrink(),
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
                        boxShadow: <BoxShadow>[BoxShadow(color: Colors.white, blurRadius: 4)],
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
        boxShadow: <BoxShadow>[BoxShadow(blurRadius: 24, spreadRadius: 16, color: Colors.black.withOpacity(0.2))],
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
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                hintText: '消費アイテム(20文字以内)',
                filled: true,
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
              ),
              style: const TextStyle(fontSize: 13, color: Colors.white),
              onTapOutside: (PointerDownEvent event) => FocusManager.instance.primaryFocus?.unfocus(),
              focusNode: focusNodeList[0],
              onTap: () => context.showKeyboard(focusNodeList[0]),
            ),
          ),
        ),
      ),
    );
  }

  ///
  Future<void> _inputSpendItem() async {
    bool errFlg = false;

    if (_spendItemEditingController.text.trim() == '') {
      errFlg = true;
    }

    if (!errFlg) {
      for (final List<Object> element in <List<Object>>[
        <Object>[_spendItemEditingController.text.trim(), 20]
      ]) {
        if (!checkInputValueLengthCheck(value: element[0].toString().trim(), length: element[1] as int)) {
          errFlg = true;
        }
      }
    }

    if (errFlg) {
      // ignore: always_specify_types
      Future.delayed(
        Duration.zero,
        () => error_dialog(
            // ignore: use_build_context_synchronously
            context: context,
            title: '登録できません。',
            content: '値を正しく入力してください。'),
      );

      return;
    }

    final SpendItem spendItem = SpendItem()
      ..spendItemName = _spendItemEditingController.text.trim()
      ..order = widget.spendItemList.length + 1
      ..defaultTime = '08:00'
      ..color = '0xffffffff';

    // ignore: always_specify_types
    await SpendItemsRepository()
        .inputSpendItem(isar: widget.isar, spendItem: spendItem)
        // ignore: always_specify_types
        .then((value) {
      _spendItemEditingController.clear();

      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  ///
  void _itemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      final DragAndDropItem movedItem = ddList[oldListIndex].children.removeAt(oldItemIndex);

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

    final AlertDialog alert = AlertDialog(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      content: const Text('このデータを消去しますか？'),
      actions: <Widget>[cancelButton, continueButton],
    );

    // ignore: inference_failure_on_function_invocation
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  ///
  Future<void> _deleteSpendItem({required int id}) async {
    //-----------------------------------
    final IsarCollection<SpendTimePlace> spendTimePlacesCollection = widget.isar.spendTimePlaces;

    final List<SpendTimePlace> getSpendTimePlaces =
        await spendTimePlacesCollection.filter().spendTypeEqualTo(spendItemNameMap[id]!).findAll();

    await widget.isar
        // ignore: avoid_function_literals_in_foreach_calls
        .writeTxn(() async => getSpendTimePlaces
            // ignore: avoid_function_literals_in_foreach_calls
            .forEach((SpendTimePlace element) async => widget.isar.spendTimePlaces.put(element..spendType = '')));
    //-----------------------------------

    final IsarCollection<SpendItem> spendItemsCollection = widget.isar.spendItems;
    await widget.isar.writeTxn(() async => spendItemsCollection.delete(id));

    if (mounted) {
      Navigator.pop(context);
    }
  }

  ///
  Future<void> _settingReorderIds() async {
    orderedIdList = <int>[];

    for (final DragAndDropList value in ddList) {
      for (final DragAndDropItem child in value.children) {
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

    final IsarCollection<SpendItem> spendItemsCollection = widget.isar.spendItems;

    await widget.isar.writeTxn(() async {
      for (int i = 0; i < orderedIdList.length; i++) {
        final SpendItem? getSpendItem = await spendItemsCollection.filter().idEqualTo(orderedIdList[i]).findFirst();
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

    // ignore: inference_failure_on_function_invocation
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey.withOpacity(0.3),
          title: const Text('Pick a color!', style: TextStyle(fontSize: 12)),
          content: BlockPicker(
            availableColors: const <Color>[
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

              // ignore: always_specify_types
              await _updateColorCode(id: id, color: color.value.toString()).then((value) {
                // ignore: use_build_context_synchronously
                Navigator.pop(context);

                // ignore: use_build_context_synchronously
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
    final int initialHour = (spendItemDefaultTimeMap[id] != null && spendItemDefaultTimeMap[id] != '')
        ? spendItemDefaultTimeMap[id]!.split(':')[0].toInt()
        : 8;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: 0),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (selectedTime != null) {
      final String time =
          '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';

      // ignore: always_specify_types
      await _updateDefaultTime(id: id, time: time).then((value) {
        if (mounted) {
          Navigator.pop(context);

          Navigator.pop(context);
        }
      });
    }
  }

  ///
  Future<void> _updateColorCode({required int id, required String color}) async {
    await widget.isar.writeTxn(() async {
      await SpendItemsRepository().getSpendItem(isar: widget.isar, id: id).then((SpendItem? value) async {
        value!.color = color;

        await SpendItemsRepository().updateSpendItem(isar: widget.isar, spendItem: value);
      });
    });
  }

  ///
  Future<void> _updateDefaultTime({required int id, required String time}) async {
    await widget.isar.writeTxn(() async {
      await SpendItemsRepository().getSpendItem(isar: widget.isar, id: id).then((SpendItem? value) async {
        value!.defaultTime = time;

        await SpendItemsRepository().updateSpendItem(isar: widget.isar, spendItem: value);
      });
    });
  }
}
