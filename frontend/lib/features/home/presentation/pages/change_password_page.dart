import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.darkGrey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.darkGrey,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security icon
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.lock_outline, size: 36, color: AppColors.gold),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Keep your account secure',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkGrey.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 32),

            _buildPasswordField(
              label: 'Current Password',
              obscure: _obscureCurrent,
              onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              label: 'New Password',
              obscure: _obscureNew,
              onToggle: () => setState(() => _obscureNew = !_obscureNew),
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              label: 'Confirm New Password',
              obscure: _obscureConfirm,
              onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            const SizedBox(height: 12),

            // Password requirements
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Password must contain:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGrey.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildRequirement('At least 8 characters'),
                  _buildRequirement('One uppercase letter'),
                  _buildRequirement('One number'),
                  _buildRequirement('One special character'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Password updated successfully!'),
                      backgroundColor: AppColors.primaryGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  'Update Password',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        obscureText: obscure,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.darkGrey),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 13, color: AppColors.darkGrey.withValues(alpha: 0.4)),
          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.gold, size: 20),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AppColors.darkGrey.withValues(alpha: 0.3),
              size: 20,
            ),
            onPressed: onToggle,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Icon(Icons.circle, size: 5, color: AppColors.darkGrey.withValues(alpha: 0.3)),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontSize: 11, color: AppColors.darkGrey.withValues(alpha: 0.45)),
          ),
        ],
      ),
    );
  }
}
