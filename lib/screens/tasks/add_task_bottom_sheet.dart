import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/shared/network/firebase/firebase_manager.dart';
import 'package:todo_app/shared/styles/colors.dart';

import '../../models/task_model.dart';
import '../../providers/tasks_provider.dart';

class TaskBottomSheet extends StatefulWidget {
  @override
  State<TaskBottomSheet> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  late DateTime selectedDate = DateTime.now();
  late TaskModel task;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TasksProvider>(context);
    return Container(
      height: 380,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("addNewTask".tr(),
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),
              TextFormField(
                validator: (value) {
                  if (titleController.text.isEmpty) {
                    return "cantLeaveEmpty".tr();
                  }
                  return null;
                },
                controller: titleController,
                decoration: InputDecoration(
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  hintText: "enterTitle".tr(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: blueColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: blueColor),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              TextFormField(
                validator: (value) {
                  if (descriptionController.text.isEmpty) {
                    return "cantLeaveEmpty".tr();
                  }
                },
                controller: descriptionController,
                decoration: InputDecoration(
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  hintText: "enterDescription".tr(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: blueColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: blueColor),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text("selectTime".tr(),
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black,
                  )),
              const SizedBox(height: 18),
              InkWell(
                onTap: () {
                  selectDate();
                  print(provider.selectedDate.toString());
                },
                child: Text(
                    provider.selectedDate != null
                        ? provider.selectedDate.toString().substring(0, 10)
                        : DateTime.now().toString().substring(0, 10),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: blueColor,
                    )),
              ),
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    addTaskPressed();
                  },
                  child: const Text("add").tr())
            ],
          ),
        ),
      ),
    );
  }

  selectDate() async {
    var provider = Provider.of<TasksProvider>(context, listen: false);

    DateTime? chosenDate = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    selectedDate = chosenDate!;
    provider.selectedDate = selectedDate;
    setState(() {});
  }

  addTaskPressed() {
    var provider = Provider.of<TasksProvider>(context, listen: false);

    if (formKey.currentState?.validate() ?? false) {
      TaskModel task = TaskModel(
        userId: FirebaseAuth.instance.currentUser!.uid,
        title: titleController.text,
        description: descriptionController.text,
        date: DateUtils.dateOnly(provider.selectedDate ?? DateTime.now())
            .millisecondsSinceEpoch,
        dateCreated: Timestamp.fromDate(DateTime.now()),
      );

      FirebaseManager.addTask(task);
      Navigator.pop(context);

      titleController.clear();
      descriptionController.clear();
      setState(() {});
    }
  }
}
