import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed; // Nếu null thì nút sẽ bị disable (xám đi)
  final bool isLoading;
  final bool isEnabled;

  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    // Logic xác định nút có bấm được không
    // Nút bị disable khi: isEnabled = false HOẶC đang isLoading HOẶC onPressed = null
    final isDisabled = !isEnabled || isLoading || onPressed == null;

    return SizedBox(
      width: double.infinity, // Full chiều ngang
      height: 50, // Chiều cao chuẩn design (48-50px)
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, // Màu nền
          disabledBackgroundColor: AppColors.textSecondary.withOpacity(
            0.3,
          ), // Màu khi disable
          foregroundColor:
              AppColors.onPrimary, // Màu hiệu ứng gợn sóng (Ripple)
          elevation: 0, // Thiết kế phẳng (Flat)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Bo góc 8px
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                title,
                style: AppTextStyles.button, // Font chữ chuẩn đã định nghĩa
              ),
      ),
    );
  }
}
