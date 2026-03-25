import 'package:flutter/material.dart';

class KiwiText extends StatelessWidget {
  const KiwiText({super.key, required this.text});

  final String text;

  ///
  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontFamily: 'KiwiMaru', fontSize: 12));
  }
}
