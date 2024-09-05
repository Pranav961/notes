import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  static Color mainColor = const Color(0xFF000633);
  static Color bgColor = const Color(0xFFE2E2FF);
  static Color accentColor = const Color(0xFF0065FF);

  static List<Color> cardsColor = [
    Colors.white,
    Colors.orange.shade100,
    Colors.red.shade100,
    Colors.pink.shade100,
    Colors.purple.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.brown.shade100,
    Colors.blueGrey.shade100,
  ];

  static TextStyle mainTitle =
      GoogleFonts.chakraPetch(fontSize: 20, fontWeight: FontWeight.bold);

  static TextStyle mainContent = GoogleFonts.nunitoSans(
    fontSize: 16,
  );

  static TextStyle dateTitle =
      GoogleFonts.chakraPetch(fontSize: 12, fontWeight: FontWeight.w500);
}
