import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/tasks_provider.dart';
import 'package:todo_app/screens/tasks/task_item.dart';
import 'package:todo_app/shared/network/firebase/firebase_manager.dart';
import 'package:todo_app/shared/styles/colors.dart';

import '../../models/task_model.dart';

class TasksTab extends StatefulWidget {
  TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TasksProvider>(context);

    return ChangeNotifierProvider(
      create: (BuildContext context) => TasksProvider(),
      child: Column(children: [
        CalendarTimeline(
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          onDateSelected: (date) {
            selectedDate = date;
            provider.changeCurrentDate(selectedDate);

            setState(() {});
          },
          leftMargin: 20,
          monthColor: Colors.black,
          dayColor: Colors.black,
          activeDayColor: Colors.white,
          activeBackgroundDayColor: blueColor,
          dotsColor: const Color(0xFF333A47),
          selectableDayPredicate: (date) => true,
          locale: 'en_ISO',
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<TaskModel>>(
            stream: FirebaseManager.getTasks(selectedDate),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                const Center(child: Text("something went wrong"));
              }
              List<TaskModel> tasks =
                  snapshot.data?.docs.map((doc) => doc.data()).toList() ?? [];
              return ListView.builder(
                  itemBuilder: (context, index) {
                    return TasksItem(tasks[index]);
                  },
                  itemCount: tasks.length);
            },
          ),
        )
      ]),
    );
  }
}
