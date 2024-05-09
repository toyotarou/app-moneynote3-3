import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../extensions/extensions.dart';

class SpendYearlyGraphAlert extends StatefulWidget {
  const SpendYearlyGraphAlert({super.key, required this.spendTotal, required this.spendTotalMap});

  final int spendTotal;
  final Map<String, int> spendTotalMap;

  ///
  @override
  State<SpendYearlyGraphAlert> createState() => _SpendYearlyGraphAlertState();
}

class _SpendYearlyGraphAlertState extends State<SpendYearlyGraphAlert> {
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
            children: [
              const SizedBox(height: 20),
              Container(width: context.screenSize.width),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('年間消費金額比率'), Container()],
              ),

              Divider(color: Colors.white.withOpacity(0.4), thickness: 5),
              // Expanded(child: _displayInputParts()),
            ],
          ),
        ),
      ),
    );
  }
}
