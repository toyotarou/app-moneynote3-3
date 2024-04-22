import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../../collections/spend_time_place.dart';
import '../../../extensions/extensions.dart';
import '../spend_item_history_alert.dart';
import 'money_dialog.dart';

class SpendItemCard extends StatelessWidget {
  const SpendItemCard({
    super.key,
    required this.spendItemName,
    required this.deleteButtonPress,
    required this.colorPickerButtonPress,
    required this.colorCode,
    required this.defaultTimeButtonPress,
    required this.defaultTime,
    required this.spendTimePlaceCountMap,
    required this.isar,
  });

  final String spendItemName;

  final VoidCallback deleteButtonPress;

  final VoidCallback colorPickerButtonPress;
  final String colorCode;

  final VoidCallback defaultTimeButtonPress;
  final String defaultTime;

  final Map<String, List<SpendTimePlace>> spendTimePlaceCountMap;

  final Isar isar;

  ///
  @override
  Widget build(BuildContext context) {
    final exDefaultTime = defaultTime.split(':');

    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(0.2))),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(spendItemName, style: TextStyle(color: Color(colorCode.toInt())), maxLines: 3, overflow: TextOverflow.ellipsis),
                Text(
                  (spendTimePlaceCountMap[spendItemName] != null) ? spendTimePlaceCountMap[spendItemName]!.length.toString() : 0.toString(),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          Row(
            children: [
              (spendTimePlaceCountMap[spendItemName] == null || spendTimePlaceCountMap[spendItemName]!.isEmpty)
                  ? const Icon(Icons.check_box_outline_blank, color: Colors.transparent)
                  : GestureDetector(
                      onTap: () {
                        MoneyDialog(
                          context: context,
                          widget: SpendItemHistoryAlert(date: DateTime.now(), isar: isar, item: spendItemName, sum: 0, from: 'spend_item_card'),
                        );
                      },
                      child: Icon(Icons.list, color: Colors.white.withOpacity(0.2)),
                    ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: defaultTimeButtonPress,
                child: Icon(
                  Icons.access_time_outlined,
                  color: (exDefaultTime[0].toInt() == 0) ? Colors.yellowAccent.withOpacity(0.3) : Colors.white.withOpacity(0.2),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(onTap: colorPickerButtonPress, child: Icon(Icons.color_lens_outlined, color: Colors.white.withOpacity(0.2))),
              const SizedBox(width: 10),
              GestureDetector(onTap: deleteButtonPress, child: Icon(Icons.delete, color: Colors.white.withOpacity(0.2))),
            ],
          ),
        ],
      ),
    );
  }
}
