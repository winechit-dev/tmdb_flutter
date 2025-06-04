import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_flutter/app/providers/localization_provider.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {
            context.read<LocalizationProvider>().setLocale('en');
          },
          child: const Text('English'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            context.read<LocalizationProvider>().setLocale('th');
          },
          child: const Text('ไทย'),
        ),
      ],
    );
  }
} 