import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController(text: 'James Anderson');
  final _emailController = TextEditingController(text: 'james.anderson@email.com');
  final _phoneController = TextEditingController(text: '+971 50 123 4567');
  final _addressController = TextEditingController(text: 'Dubai Marina, Dubai, UAE');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

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
          'Edit Profile',
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
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE8F0EA),
                      border: Border.all(color: const Color(0xFFD5E0D8), width: 2),
                    ),
                    child: const Center(
                      child: Text(
                        'JA',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt, size: 16, color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Form fields
            _buildTextField('Full Name', _nameController, Icons.person_outline),
            const SizedBox(height: 16),
            _buildTextField('Email Address', _emailController, Icons.email_outlined),
            const SizedBox(height: 16),
            _buildTextField('Phone Number', _phoneController, Icons.phone_outlined),
            const SizedBox(height: 16),
            _buildTextField('Address', _addressController, Icons.location_on_outlined),
            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Profile updated successfully!'),
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
                  'Save Changes',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
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
        controller: controller,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.darkGrey),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 13,
            color: AppColors.darkGrey.withValues(alpha: 0.4),
          ),
          prefixIcon: Icon(icon, color: AppColors.primaryGreen, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
