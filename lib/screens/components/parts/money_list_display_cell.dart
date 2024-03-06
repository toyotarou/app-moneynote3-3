import 'package:flutter/material.dart';

class MoneyListDisplayCell extends StatelessWidget {
  const MoneyListDisplayCell(
      {super.key,
      required this.widget,
      required this.width,
      this.minHeight,
      required this.color,
      required this.borderColor,
      required this.alignment});

  final Widget widget;

  final double width;
  final double? minHeight;

  final Color color;
  final Color borderColor;

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: borderColor), color: color),
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.all(1),
      width: width,
      alignment: alignment,
      child: (minHeight != null)
          ? ConstrainedBox(
              constraints: BoxConstraints(minHeight: minHeight!),
              child: widget,
            )
          : widget,
    );
  }
}
