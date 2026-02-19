import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AboutSanzenPage extends StatelessWidget {
  const AboutSanzenPage({super.key});

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
          'About Sanzen',
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
            // Logo / Brand card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 36),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1D3724), Color(0xFF0E552B)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Center(
                      child: Text(
                        'S',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'SANZEN',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Properties',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white.withValues(alpha: 0.7),
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // About section
            _buildCard(
              title: 'Our Story',
              content:
                  'Sanzen Properties is a premier real estate developer based in Dubai, UAE. '
                  'Founded with a vision to redefine modern living, Sanzen creates exceptional '
                  'residential communities that blend architectural excellence with sustainable design.\n\n'
                  'With over 15 years of experience in the UAE\'s dynamic real estate market, '
                  'we have developed award-winning projects that set new benchmarks in quality, '
                  'innovation, and customer satisfaction.',
            ),
            const SizedBox(height: 12),

            // Mission & Vision
            _buildCard(
              title: 'Our Mission',
              content:
                  'To build sustainable, innovative living spaces that enhance the quality of life '
                  'for our homeowners, while setting new standards of excellence in the real estate industry.',
            ),
            const SizedBox(height: 12),
            _buildCard(
              title: 'Our Vision',
              content:
                  'To be the most trusted and admired real estate developer in the Middle East, '
                  'known for creating communities that people are proud to call home.',
            ),
            const SizedBox(height: 12),

            // Key numbers
            _buildCard(
              title: 'By the Numbers',
              child: Row(
                children: [
                  _buildStatItem('15+', 'Years'),
                  _buildStatDivider(),
                  _buildStatItem('2,500+', 'Units'),
                  _buildStatDivider(),
                  _buildStatItem('12', 'Projects'),
                  _buildStatDivider(),
                  _buildStatItem('4.8★', 'Rating'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Social links
            _buildCard(
              title: 'Follow Us',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(Icons.language, 'Website'),
                  const SizedBox(width: 20),
                  _buildSocialIcon(Icons.camera_alt_outlined, 'Instagram'),
                  const SizedBox(width: 20),
                  _buildSocialIcon(Icons.people_outlined, 'LinkedIn'),
                  const SizedBox(width: 20),
                  _buildSocialIcon(Icons.play_circle_outline, 'YouTube'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // App version
            Text(
              'Sanzen App v1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.darkGrey.withValues(alpha: 0.35),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '© 2025 Sanzen Properties LLC. All rights reserved.',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.darkGrey.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, String? content, Widget? child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.darkGrey.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGrey.withValues(alpha: 0.4),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          if (content != null)
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey.withValues(alpha: 0.65),
                height: 1.6,
              ),
            ),
          if (child != null) child,
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.darkGrey.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 32,
      color: AppColors.darkGrey.withValues(alpha: 0.06),
    );
  }

  Widget _buildSocialIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F5F1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 22, color: AppColors.primaryGreen),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.darkGrey.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}
