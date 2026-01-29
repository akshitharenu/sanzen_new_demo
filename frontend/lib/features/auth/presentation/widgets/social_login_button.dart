import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SocialLoginButton extends StatelessWidget {
  final String label;
  final String iconAsset;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.iconAsset,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? AppColors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconAsset,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
