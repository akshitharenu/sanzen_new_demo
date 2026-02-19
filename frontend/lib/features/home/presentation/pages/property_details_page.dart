import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PropertyDetailsPage extends StatelessWidget {
  final String propertyName;
  final String location;
  final String unitCode;
  final String type;
  final String bedrooms;
  final String area;
  final String status;
  final Color statusColor;
  final double? progress;
  final String imageAsset;

  const PropertyDetailsPage({
    super.key,
    required this.propertyName,
    required this.location,
    required this.unitCode,
    required this.type,
    required this.bedrooms,
    required this.area,
    required this.status,
    required this.statusColor,
    this.progress,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // Hero image
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 18),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(imageAsset, fit: BoxFit.cover),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.65),
                        ],
                        stops: const [0.3, 1.0],
                      ),
                    ),
                  ),
                  // Property name overlay
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            status,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          propertyName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 15, color: AppColors.white.withValues(alpha: 0.85)),
                            const SizedBox(width: 4),
                            Text(
                              location,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.white.withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Specs row
                  Row(
                    children: [
                      _buildSpecCard(Icons.home_outlined, 'Type', type),
                      const SizedBox(width: 10),
                      _buildSpecCard(Icons.bed_outlined, 'Bedrooms', bedrooms),
                      const SizedBox(width: 10),
                      _buildSpecCard(Icons.square_foot, 'Area', area),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Unit details card
                  _buildSectionCard(
                    title: 'Unit Details',
                    child: Column(
                      children: [
                        _buildDetailRow('Unit Code', unitCode),
                        _buildCardDivider(),
                        _buildDetailRow('Floor', '2nd Floor'),
                        _buildCardDivider(),
                        _buildDetailRow('Parking', '2 Covered Spaces'),
                        _buildCardDivider(),
                        _buildDetailRow('Balcony', 'Yes — Lake View'),
                        _buildCardDivider(),
                        _buildDetailRow('Furnished', 'Semi-Furnished'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Progress section (if applicable)
                  if (progress != null) ...[
                    _buildSectionCard(
                      title: 'Construction Progress',
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Overall Completion',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.darkGrey.withValues(alpha: 0.7),
                                ),
                              ),
                              Text(
                                '${(progress! * 100).toInt()}%',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: progress!,
                              minHeight: 8,
                              backgroundColor: AppColors.lightGrey.withValues(alpha: 0.5),
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow('Current Phase', 'Structure'),
                          _buildCardDivider(),
                          _buildDetailRow('Est. Completion', 'Dec 2024'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Payment plan card
                  _buildSectionCard(
                    title: 'Payment Plan',
                    child: Column(
                      children: [
                        _buildPaymentRow('Down Payment', '20%', true),
                        _buildCardDivider(),
                        _buildPaymentRow('During Construction', '50%', progress != null && progress! < 1.0),
                        _buildCardDivider(),
                        _buildPaymentRow('On Handover', '30%', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Amenities card
                  _buildSectionCard(
                    title: 'Amenities',
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildAmenityChip(Icons.pool, 'Pool'),
                        _buildAmenityChip(Icons.fitness_center, 'Gym'),
                        _buildAmenityChip(Icons.local_parking, 'Parking'),
                        _buildAmenityChip(Icons.security, 'Security'),
                        _buildAmenityChip(Icons.park, 'Garden'),
                        _buildAmenityChip(Icons.child_care, 'Kids Area'),
                        _buildAmenityChip(Icons.spa, 'Spa'),
                        _buildAmenityChip(Icons.restaurant, 'BBQ Area'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Contact button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Your property manager will contact you shortly.'),
                            backgroundColor: AppColors.primaryGreen,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.headset_mic_outlined, size: 20),
                      label: const Text(
                        'Contact Property Manager',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecCard(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
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
          children: [
            Icon(icon, size: 22, color: AppColors.primaryGreen),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.darkGrey.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGrey.withValues(alpha: 0.4),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.darkGrey.withValues(alpha: 0.6),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String percentage, bool isPaid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            isPaid ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 18,
            color: isPaid ? AppColors.primaryGreen : AppColors.lightGrey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.darkGrey.withValues(alpha: isPaid ? 0.8 : 0.5),
              ),
            ),
          ),
          Text(
            percentage,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isPaid ? AppColors.primaryGreen : AppColors.darkGrey.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardDivider() {
    return Divider(color: AppColors.darkGrey.withValues(alpha: 0.06), height: 1);
  }

  Widget _buildAmenityChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5F1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryGreen),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
}
