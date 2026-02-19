import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selectedLanguage = 'English';

  final List<_LanguageItem> _languages = [
    _LanguageItem(name: 'English', nativeName: 'English', flag: '🇬🇧'),
    _LanguageItem(name: 'Arabic', nativeName: 'العربية', flag: '🇦🇪'),
    _LanguageItem(name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳'),
    _LanguageItem(name: 'Chinese', nativeName: '中文', flag: '🇨🇳'),
    _LanguageItem(name: 'French', nativeName: 'Français', flag: '🇫🇷'),
    _LanguageItem(name: 'Russian', nativeName: 'Русский', flag: '🇷🇺'),
    _LanguageItem(name: 'Urdu', nativeName: 'اردو', flag: '🇵🇰'),
    _LanguageItem(name: 'Spanish', nativeName: 'Español', flag: '🇪🇸'),
  ];

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
          'Language',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.darkGrey,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              itemCount: _languages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final lang = _languages[index];
                final isSelected = _selectedLanguage == lang.name;
                return GestureDetector(
                  onTap: () => setState(() => _selectedLanguage = lang.name),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.darkGrey.withValues(alpha: 0.06),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Row(
                      children: [
                        Text(lang.flag, style: const TextStyle(fontSize: 26)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang.name,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  color: AppColors.darkGrey,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                lang.nativeName,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.darkGrey.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 22)
                        else
                          Icon(
                            Icons.radio_button_unchecked,
                            color: AppColors.darkGrey.withValues(alpha: 0.15),
                            size: 22,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Confirm button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Language set to $_selectedLanguage'),
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
                  'Confirm',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageItem {
  final String name;
  final String nativeName;
  final String flag;

  const _LanguageItem({
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}
