import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

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
          'Help & Support',
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
            // Contact card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1D3724), Color(0xFF0E552B)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.headset_mic_outlined, size: 40, color: AppColors.white),
                  const SizedBox(height: 12),
                  const Text(
                    'Need Help?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Our support team is available\nSun–Thu, 9 AM – 6 PM (GST)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.white.withValues(alpha: 0.75),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildContactButton(
                          icon: Icons.phone_outlined,
                          label: 'Call Us',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Dialing +971 4 123 4567...'),
                                backgroundColor: AppColors.primaryGreen,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildContactButton(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Opening email to support@sanzen.ae...'),
                                backgroundColor: AppColors.primaryGreen,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // FAQ section
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGrey.withValues(alpha: 0.4),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),

            _buildFaqTile(
              question: 'How do I track my construction progress?',
              answer:
                  'You can view your construction timeline from the home screen by tapping "View Timeline". This shows all construction milestones, including completed, in-progress, and upcoming phases.',
            ),
            const SizedBox(height: 8),
            _buildFaqTile(
              question: 'How do I make a payment?',
              answer:
                  'Navigate to the Documents tab to view your payment schedule. You can make payments through bank transfer using the details provided in your Sales Purchase Agreement, or contact your property manager for assistance.',
            ),
            const SizedBox(height: 8),
            _buildFaqTile(
              question: 'Can I customize my unit?',
              answer:
                  'Yes! Check out the Exclusive Add-ons section on the home screen for available customization options including Private Pool, EV Charger, Home Automation, and more.',
            ),
            const SizedBox(height: 8),
            _buildFaqTile(
              question: 'How do I download my documents?',
              answer:
                  'Go to the Documents tab from the bottom navigation bar. You\'ll find all your contracts, receipts, and NOC documents. Tap the download icon next to any document to save it to your device.',
            ),
            const SizedBox(height: 8),
            _buildFaqTile(
              question: 'When will my unit be ready for handover?',
              answer:
                  'The estimated completion date is shown on your property card on the home screen and in the construction timeline. You\'ll receive a notification when the handover date is confirmed.',
            ),
            const SizedBox(height: 24),

            // Submit request button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Support request submitted! We\'ll get back to you within 24 hours.'),
                      backgroundColor: AppColors.primaryGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                icon: const Icon(Icons.send_outlined, size: 18),
                label: const Text(
                  'Submit a Request',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen,
                  side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqTile({required String question, required String answer}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: AppColors.primaryGreen,
          collapsedIconColor: AppColors.darkGrey.withValues(alpha: 0.3),
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.darkGrey,
            ),
          ),
          children: [
            Text(
              answer,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.darkGrey.withValues(alpha: 0.6),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
