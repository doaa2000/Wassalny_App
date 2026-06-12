import 'package:flutter/material.dart';

/// Static geometry + palette for the stylized Cairo map, transcribed from the
/// `MapView` design component (light theme). All coordinates live in the
/// design's 390×700 view-box and are scaled to cover the host container.
class MapGeometry {
  MapGeometry._();

  static const Size viewBox = Size(390, 700);

  // ---- Light palette ----
  static const Color base = Color(0xFFE7EBEE);
  static const List<Color> tones = [
    Color(0xFFDFE4E8),
    Color(0xFFE2E6E9),
    Color(0xFFDBE0E4),
  ];
  static const Color park = Color(0xFFD4E7CE);
  static const Color road = Color(0xFFFFFFFF);
  static const Color avenue = Color(0xFFFFFFFF);
  static const Color avenueSoft = Color(0xFFF1F4F6);
  static const Color water = Color(0xFFBCDAEC);
  static const Color waterStroke = Color(0xFFAAD0E6);
  static const Color bridge = Color(0xFFFFFFFF);
  static const Color taxiBg = Color(0xFFFFFFFF);
  static const Color taxiIcon = Color(0xFF2B2420);
  static const Color taxiMuted = Color(0xFF9FB1BF);
  static const Color pinFill = Color(0xFF2B2420);
  static const Color pinBorder = Color(0xFFFFFFFF);

  // ---- Roads: [x, y, w, h] ----
  static const List<List<double>> roads = [
    [-10, 86, 410, 9], [-10, 186, 410, 8], [-10, 298, 410, 10],
    [-10, 410, 410, 8], [-10, 520, 410, 9], [-10, 628, 410, 8],
    [56, -10, 9, 720], [128, -10, 8, 720], [198, -10, 9, 720],
  ];

  // ---- City blocks: [x, y, w, h, toneIndex] ----
  static const List<List<double>> blocks = [
    [8, 96, 38, 80, 0], [70, 96, 48, 80, 1], [142, 96, 44, 80, 2],
    [8, 198, 38, 78, 1], [142, 198, 44, 78, 0], [8, 320, 38, 78, 2],
    [70, 320, 48, 78, 1], [142, 320, 44, 78, 0], [8, 432, 38, 76, 1],
    [70, 432, 48, 76, 2], [8, 542, 38, 74, 0], [70, 542, 48, 74, 1],
    [142, 542, 44, 74, 2], [356, 96, 30, 80, 1], [356, 432, 30, 76, 0],
  ];

  // ---- Nearby taxis (idle): position in view-box coords + rotation ----
  static const List<List<double>> taxis = [
    [124, 280, -12], [234, 238, 8], [257, 420, -6],
    [101, 448, 14], [195, 504, 4],
  ];

  // User location in view-box coords.
  static const Offset user = Offset(179, 350);

  // Route endpoints (match the route path start/end).
  static const Offset pickup = Offset(96, 168);
  static const Offset dropoff = Offset(300, 556);
}
