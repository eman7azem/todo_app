import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              context.setLocale(const Locale("en", "US"));
              Navigator.pop(context);
            },
            child: const Text(
              "english",
              style: TextStyle(fontSize: 45),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {
              context.setLocale(const Locale("ar", "EG"));
              Navigator.pop(context);
            },
            child: const Text(
              "arabic",
              style: TextStyle(fontSize: 45),
            ),
          ),
        ],
      ),
    );
  }
}
