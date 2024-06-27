import 'package:flutter/widgets.dart';

class TasksProvider extends ChangeNotifier {
  late DateTime? selectedDate;
  TasksProvider({this.selectedDate}) {
    notifyListeners();
  }
  changeCurrentDate(date) {
    selectedDate = date;
    notifyListeners();
  }
}
