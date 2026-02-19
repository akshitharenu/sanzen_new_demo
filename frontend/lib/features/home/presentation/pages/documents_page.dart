import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  int _selectedCategory = 0;

  final List<String> _categories = ['All', 'Contracts', 'Receipts', 'NOC'];

  final List<_DocumentItem> _documents = [
    _DocumentItem(
      name: 'Sales Purchase Agreement',
      category: 'Contracts',
      date: 'Jan 15, 2025',
      size: '2.4 MB',
      icon: Icons.description,
      iconBgColor: const Color(0xFFE8F5E9),
      iconColor: AppColors.primaryGreen,
    ),
    _DocumentItem(
      name: 'Payment Receipt - Q4 2024',
      category: 'Receipts',
      date: 'Dec 28, 2024',
      size: '540 KB',
      icon: Icons.receipt_long,
      iconBgColor: const Color(0xFFFFF3E0),
      iconColor: const Color(0xFFE65100),
    ),
    _DocumentItem(
      name: 'No Objection Certificate',
      category: 'NOC',
      date: 'Dec 10, 2024',
      size: '1.1 MB',
      icon: Icons.verified_outlined,
      iconBgColor: const Color(0xFFE3F2FD),
      iconColor: const Color(0xFF1565C0),
    ),
    _DocumentItem(
      name: 'Unit Handover Agreement',
      category: 'Contracts',
      date: 'Nov 20, 2024',
      size: '3.2 MB',
      icon: Icons.handshake_outlined,
      iconBgColor: const Color(0xFFE8F5E9),
      iconColor: AppColors.primaryGreen,
    ),
    _DocumentItem(
      name: 'Payment Receipt - Q3 2024',
      category: 'Receipts',
      date: 'Sep 30, 2024',
      size: '480 KB',
      icon: Icons.receipt_long,
      iconBgColor: const Color(0xFFFFF3E0),
      iconColor: const Color(0xFFE65100),
    ),
    _DocumentItem(
      name: 'Parking NOC',
      category: 'NOC',
      date: 'Sep 12, 2024',
      size: '890 KB',
      icon: Icons.local_parking,
      iconBgColor: const Color(0xFFE3F2FD),
      iconColor: const Color(0xFF1565C0),
    ),
    _DocumentItem(
      name: 'Interior Modification Contract',
      category: 'Contracts',
      date: 'Aug 05, 2024',
      size: '1.8 MB',
      icon: Icons.design_services_outlined,
      iconBgColor: const Color(0xFFF3E5F5),
      iconColor: const Color(0xFF7B1FA2),
    ),
  ];

  List<_DocumentItem> get _filteredDocuments {
    if (_selectedCategory == 0) return _documents;
    final category = _categories[_selectedCategory];
    return _documents.where((d) => d.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildCategoryChips(),
          Expanded(
            child: _buildDocumentList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Files',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkGrey.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'My Documents',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.search,
              color: AppColors.primaryGreen,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_categories.length, (index) {
            final isSelected = _selectedCategory == index;
            return Padding(
              padding: EdgeInsets.only(right: index < _categories.length - 1 ? 10 : 0),
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategory = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryGreen : AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : AppColors.lightGrey,
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primaryGreen.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                  ),
                  child: Text(
                    _categories[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.white : AppColors.darkGrey,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildDocumentList() {
    final docs = _filteredDocuments;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      itemCount: docs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildDocumentCard(docs[index]),
    );
  }

  Widget _buildDocumentCard(_DocumentItem doc) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          // Document icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: doc.iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(doc.icon, color: doc.iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          // Document info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        doc.category,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${doc.date}  •  ${doc.size}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.darkGrey.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Download / view button
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.download_outlined,
                color: AppColors.primaryGreen,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentItem {
  final String name;
  final String category;
  final String date;
  final String size;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  const _DocumentItem({
    required this.name,
    required this.category,
    required this.date,
    required this.size,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  });
}
