import 'package:flutter/material.dart';

/// Palette neutre, calme, sans gradients.
class AppColors {
  AppColors._();

  // Neutres
  static const white = Color(0xFFFFFFFF);
  static const gray50 = Color(0xFFF8FAFC);
  static const gray100 = Color(0xFFF1F5F9);
  static const gray200 = Color(0xFFE2E8F0);
  static const gray500 = Color(0xFF64748B);
  static const gray700 = Color(0xFF334155);
  static const gray900 = Color(0xFF0F172A);

  // Accent (bleu nuit / vert profond)
  static const navy = Color(0xFF0B2A3F);
  static const deepGreen = Color(0xFF0B3D2E);

  static const success = Color(0xFF166534);
  static const warning = Color(0xFF92400E);
  static const danger = Color(0xFF991B1B);

  static ColorScheme schemeLight({Color seed = navy}) {
    final base = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light);
    return base.copyWith(
      surface: white,
      surfaceContainerHighest: gray100,
      outline: gray200,
      onSurface: gray900,
      onSurfaceVariant: gray700,
    );
  }
}

