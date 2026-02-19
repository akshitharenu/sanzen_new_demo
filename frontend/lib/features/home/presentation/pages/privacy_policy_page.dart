import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
          'Privacy Policy',
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
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Last updated
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Last Updated: January 1, 2025',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildSection(
                '1. Information We Collect',
                'Sanzen Properties ("we", "us", or "our") collects personal information that you voluntarily provide when you register for an account, express interest in obtaining information about us or our products, or otherwise contact us.\n\n'
                    'Personal information may include your name, email address, phone number, mailing address, property preferences, payment information, and any other information you choose to provide.',
              ),
              _buildSection(
                '2. How We Use Your Information',
                'We use the information we collect to:\n\n'
                    '• Provide, operate, and maintain our services\n'
                    '• Process transactions and send related information\n'
                    '• Send you construction updates and property notifications\n'
                    '• Respond to your comments, questions, and requests\n'
                    '• Send you technical notices, updates, and security alerts\n'
                    '• Provide personalized content and recommendations\n'
                    '• Monitor and analyze usage trends and preferences',
              ),
              _buildSection(
                '3. Information Sharing',
                'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this privacy policy.\n\n'
                    'We may share your information with trusted service providers who assist us in operating our platform, conducting our business, or servicing you, so long as those parties agree to keep this information confidential.',
              ),
              _buildSection(
                '4. Data Security',
                'We implement industry-standard security measures to maintain the safety of your personal information. Your data is encrypted in transit and at rest using AES-256 encryption.\n\n'
                    'However, no method of transmission over the Internet or method of electronic storage is 100% secure, and we cannot guarantee its absolute security.',
              ),
              _buildSection(
                '5. Data Retention',
                'We retain your personal information only for as long as necessary to fulfill the purposes for which we collected it, including for the purposes of satisfying any legal, accounting, or reporting requirements.\n\n'
                    'Upon account deletion or request, your personal data will be removed within 30 days, unless retention is required by law.',
              ),
              _buildSection(
                '6. Your Rights',
                'Depending on your location, you may have the following rights regarding your personal data:\n\n'
                    '• Right to access your personal information\n'
                    '• Right to rectify inaccurate data\n'
                    '• Right to erasure of your data\n'
                    '• Right to restrict processing\n'
                    '• Right to data portability\n'
                    '• Right to object to processing',
              ),
              _buildSection(
                '7. Contact Us',
                'If you have questions or concerns about this privacy policy, please contact us at:\n\n'
                    'Sanzen Properties LLC\n'
                    'Email: privacy@sanzen.ae\n'
                    'Phone: +971 4 123 4567\n'
                    'Address: Downtown Dubai, UAE',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.darkGrey.withValues(alpha: 0.6),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
