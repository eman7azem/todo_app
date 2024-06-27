import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/tasks_provider.dart';
import 'package:todo_app/screens/login/login.dart';
import 'package:todo_app/screens/settings/settings_tab.dart';
import 'package:todo_app/screens/tasks/task_tab.dart';
import 'package:todo_app/shared/styles/colors.dart';

import '../providers/my_provider.dart';
import '../screens/tasks/add_task_bottom_sheet.dart';

class HomeLayout extends StatefulWidget {
  static const String routeName = "HomeLayout";

  HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int index = 0;
  List<Widget> tabs = [TasksTab(), SettingTab()];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      backgroundColor: mintGreen,
      appBar: AppBar(
        title: const Text(
            // ${provider.userModel?.name != null ? provider.userModel?.name : ""}
            "hello").tr(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.white, width: 3)),
        onPressed: () {
          showAddTaskBottomSheet();
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 50,
        notchMargin: 8,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: BottomNavigationBar(
          selectedFontSize: 0,
          unselectedFontSize: 0,
          elevation: 0,
          // type: BottomNavigationBarType.shifting,
          currentIndex: index,
          onTap: (value) {
            index = value;
            setState(() {});
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.list,
                  color: Colors.black,
                ),
                label: "Tasks",
                backgroundColor: Colors.transparent),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                label: "Settings",
                backgroundColor: Colors.transparent),
          ],
        ),
      ),
      body: tabs[index],
    );
  }
  showAddTaskBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: TaskBottomSheet());
        });
  }
}
