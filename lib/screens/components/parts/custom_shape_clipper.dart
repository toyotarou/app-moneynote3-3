// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width * 0.4, size.height * 0.1)
      ..lineTo(size.width * 0.4, size.height * 0.5)
      ..lineTo(size.width, 0);
  }

  @override
  // ignore: strict_raw_type, always_specify_types
  bool shouldReclip(CustomClipper oldClipper) => true;
}
