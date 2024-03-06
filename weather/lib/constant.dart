import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Const {
  static const String baseUrl = 'https://api.weatherapi.com/v1/';
  static TextStyle headfont =
      GoogleFonts.lexend(color: Colors.white, fontSize: 40);
  static TextStyle headfontblc =
      GoogleFonts.lexend(color: Colors.black, fontSize: 40);
  static TextStyle headfontmed =
      GoogleFonts.lexend(color: Colors.white, fontSize: 25);
  static TextStyle subheadfont = GoogleFonts.lexend(
      color: Colors.grey.shade500, fontSize: 18, fontWeight: FontWeight.w400);
  static TextStyle subheadfontblc = GoogleFonts.lexend(
      color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400);
  static TextStyle headfontmedblc =
      GoogleFonts.lexend(color: Colors.black, fontSize: 25);

  static TextStyle subheadfontwhi = GoogleFonts.lexend(
      color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400);
  static TextStyle headfontmedwhi =
      GoogleFonts.lexend(color: Colors.white, fontSize: 25);
  static TextStyle subheadfontmidwhi = GoogleFonts.lexend(
      color: Colors.white60, fontSize: 18, fontWeight: FontWeight.w400);
  static String apiKey = "627f38bdde4f4bd296e71004240403";

  static List<String> city = [
    "Surat",
    "Mumbai",
    "Ahmedabad",
    "Tokyo",
    "Moscow"
  ];
}
