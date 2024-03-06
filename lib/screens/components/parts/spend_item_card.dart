import 'package:flutter/material.dart';

import '../../../collections/spend_time_place.dart';
import '../../../extensions/extensions.dart';

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
  });

  final String spendItemName;

  final VoidCallback deleteButtonPress;

  final VoidCallback colorPickerButtonPress;
  final String colorCode;

  final VoidCallback defaultTimeButtonPress;
  final String defaultTime;

  final Map<String, List<SpendTimePlace>> spendTimePlaceCountMap;

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
          Expanded(child: Text(spendItemName, style: TextStyle(color: Color(colorCode.toInt())))),
          Expanded(
            child: Container(
              alignment: Alignment.topRight,
              child: Text(
                (spendTimePlaceCountMap[spendItemName] != null)
                    ? spendTimePlaceCountMap[spendItemName]!.length.toString()
                    : 0.toString(),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Row(
              children: [
                GestureDetector(
                  onTap: defaultTimeButtonPress,
                  child: Icon(
                    Icons.access_time_outlined,
                    color: (exDefaultTime[0].toInt() == 0)
                        ? Colors.yellowAccent.withOpacity(0.3)
                        : Colors.white.withOpacity(0.2),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: colorPickerButtonPress,
                  child: Icon(Icons.color_lens_outlined, color: Colors.white.withOpacity(0.2)),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: deleteButtonPress,
                  child: Icon(Icons.delete, color: Colors.white.withOpacity(0.2)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
