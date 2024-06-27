import 'package:flutter/widgets.dart';

class LanguageProvider extends ChangeNotifier {
  late String lan1Code;
  late String lan2Code;
  changeLanguage(lan1, lan2) {
    lan1Code = lan1;
    lan1Code = lan2;
  }
}
