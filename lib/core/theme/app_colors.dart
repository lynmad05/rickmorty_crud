import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color wine900 = Color(0xFF3D0814);
  static const Color wine800 = Color(0xFF551020);
  static const Color wine700 = Color(0xFF6B1A2A);
  static const Color wine600 = Color(0xFF8C2331);
  static const Color wine500 = Color(0xFFA83848);
  static const Color wine400 = Color(0xFFC15A67);
  static const Color wine300 = Color(0xFFD98C97);
  static const Color wine200 = Color(0xFFEBBAC0);
  static const Color wine100 = Color(0xFFF6DEE1);
  static const Color wine50 = Color(0xFFFCF1F2);

  static const Color background = Color(0xFFFDF5F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2B0A10);
  static const Color textSecondary = Color(0xFF7A5459);
  static const Color divider = Color(0xFFF0DCDF);

  static const Color statusAlive = Color(0xFF6B8C5A);
  static const Color statusDead = wine700;
  static const Color statusUnknown = Color(0xFFB09090);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [wine900, wine700, wine600],
  );

  static const LinearGradient cardScrim = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC2B0A10)],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [wine800, wine600],
  );
}
