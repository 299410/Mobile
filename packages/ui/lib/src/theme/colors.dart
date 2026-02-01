import 'package:flutter/material.dart';

class AppColors {
  // 1. Brand Colors (Màu thương hiệu)
  static const Color primary = Color(0xFFF26F21); // Cam FPT
  static const Color onPrimary = Colors.white; // Chữ trên nền Cam

  static const Color secondary = Color(
    0xFF0054A6,
  ); // Xanh đậm (thường dùng cho Header)
  static const Color onSecondary = Colors.white;

  // 2. Background Colors (Màu nền)
  static const Color background = Color(
    0xFFF9FAFB,
  ); // Xám rất nhạt (chuẩn Modern UI)
  static const Color surface = Colors.white; // Nền của các Card/Dialog

  // 3. Text Colors (Màu chữ)
  static const Color textPrimary = Color(0xFF111827); // Đen đậm (Tiêu đề)
  static const Color textSecondary = Color(0xFF6B7280); // Xám (Mô tả phụ)

  // 4. Status Colors (Trạng thái)
  static const Color success = Color(0xFF10B981); // Xanh lá (Đạt)
  static const Color error = Color(0xFFEF4444); // Đỏ (Trượt/Lỗi)
  static const Color warning = Color(0xFFF59E0B); // Vàng (Chờ duyệt)
}
