import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_flutter/app/providers/localization_provider.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.watch<LocalizationProvider>().locale;
    final currentLanguage = currentLocale.languageCode == 'en' ? 'English' : 'ไทย';

    return PopupMenuButton<String>(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Chip(
            label: Text(
              currentLanguage,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            avatar: const Icon(Icons.language, size: 18, color: Colors.black87),
            backgroundColor: Colors.grey.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.black12, width: 1),
            ),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            elevation: 0,
          ),
        ],
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'en',
          child: Row(
            children: [
              const Text('English'),
              if (currentLocale.languageCode == 'en')
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check, size: 18),
                ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'th',
          child: Row(
            children: [
              const Text('ไทย'),
              if (currentLocale.languageCode == 'th')
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check, size: 18),
                ),
            ],
          ),
        ),
      ],
      onSelected: (String languageCode) {
        context.read<LocalizationProvider>().setLocale(languageCode);
      },
    );
  }
}
