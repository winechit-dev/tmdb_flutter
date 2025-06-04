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
          Text(
            currentLanguage,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.black87),
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
                  padding: EdgeInsets.only(left: 8.0),
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
                  padding: EdgeInsets.only(left: 8.0),
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