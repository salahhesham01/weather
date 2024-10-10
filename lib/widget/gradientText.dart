import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget gradientText(String text, double fontSize, FontWeight fontWeight) {
  return ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (bounds) => const LinearGradient(
      colors: [Color(0xFFFFA500), Color(0xFFFFFFFF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds),
    child: Text(
      text,
      style: GoogleFonts.openSans(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    ),
  );
}
