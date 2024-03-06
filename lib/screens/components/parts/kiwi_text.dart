import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KiwiText extends StatelessWidget {
  const KiwiText({super.key, required this.text});

  final String text;

  ///
  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.kiwiMaru(fontSize: 12));
  }
}
