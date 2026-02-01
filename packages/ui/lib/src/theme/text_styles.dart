import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  // Font cơ sở (Base Font) - Ví dụ dùng Inter hoặc Roboto
  static final _baseFont = GoogleFonts.inter();

  // 1. Headlines (Tiêu đề to)
  static TextStyle get h1 => _baseFont.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700, // Bold
    color: AppColors.textPrimary,
  );

  static TextStyle get h2 => _baseFont.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
  );

  // 2. Body text (Nội dung thường)
  static TextStyle get bodyLarge => _baseFont.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => _baseFont.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // 3. Button text (Chữ trên nút)
  static TextStyle get button => _baseFont.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
  );
}
