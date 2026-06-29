import 'package:flutter/material.dart';

class AppColors {
  // Primary Smoke / Charcoal Vibe
  static const Color primary = Color(0xFF2F3542);
  static const Color primaryLight = Color(0xFF747D8C);
  static const Color primaryDark = Color(0xFF212529);
  static const Color primarySurface = Color(0xFFEAECEE);
  static const Color primaryBorder = Color(0xFFCED4DA);

  // Semantic
  static const Color green = Color(0xFF16A571);
  static const Color greenSurface = Color(0xFFE8F8F2);
  static const Color amber = Color(0xFFFF7A00); // Glowing Ember Orange
  static const Color amberSurface = Color(0xFFFFF0E5);
  static const Color red = Color(0xFFE5484D);
  static const Color redSurface = Color(0xFFFDECED);
  static const Color violet = Color(0xFF7A5AF8);
  static const Color violetSurface = Color(0xFFF0EEFF);

  // Neutral
  static const Color ink = Color(0xFF1A1D20);
  static const Color slate600 = Color(0xFF495057);
  static const Color slate500 = Color(0xFF6C757D);
  static const Color slate400 = Color(0xFFADB5BD);
  static const Color slate300 = Color(0xFFDEE2E6);
  static const Color line = Color(0xFFE9ECEF);
  static const Color line2 = Color(0xFFF8F9FA);
  static const Color bg = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);

  // Gradient (Smoke/Cloud style)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
    colors: [
      Color(0xFF868E96), // Cloud Gray / Light Smoke
      Color(0xFF495057), // Charcoal / Medium Smoke
      Color(0xFF212529), // Carbon / Deep Ash
    ],
  );

  // Shadows
  static List<BoxShadow> shadowCard = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 24,
      spreadRadius: 0,
      offset: Offset(0, 4),
    ),
  ];
  static List<BoxShadow> shadowSoft = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 12,
      spreadRadius: 0,
      offset: Offset(0, 2),
    ),
  ];
  static List<BoxShadow> shadowPrimary = [
    BoxShadow(
      color: Color(0x332F3542),
      blurRadius: 22,
      spreadRadius: 0,
      offset: Offset(0, 10),
    ),
  ];

  // Tone map for FeatureIcon
  static Map<String, List<Color>> tones = {
    'blue': [primarySurface, primary],
    'green': [greenSurface, green],
    'amber': [amberSurface, amber],
    'red': [redSurface, red],
    'violet': [violetSurface, violet],
    'slate': [bg, slate600],
  };

  static List<Color> tone(String name) => tones[name] ?? tones['blue']!;
}
