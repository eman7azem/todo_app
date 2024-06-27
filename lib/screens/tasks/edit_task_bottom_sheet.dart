import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/tasks_provider.dart';
import 'package:todo_app/shared/network/firebase/firebase_manager.dart';
import 'package:todo_app/shared/styles/colors.dart';

import '../../models/task_model.dart';

class EditTaskBottomSheet extends StatefulWidget {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TaskModel task;

  EditTaskBottomSheet({required this.task, super.key}) {
    titleController.text = task.title;
    descriptionController.text = task.description;
    // task.id = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  State<EditTaskBottomSheet> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<EditTaskBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TasksProvider>(context);
    widget.selectedDate = provider.selectedDate ?? DateTime.now();

    return Container(
      height: 380,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("editTask".tr(),
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 18),
            TextFormField(
              controller: widget.titleController,
              decoration: InputDecoration(
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
              controller: widget.descriptionController,
              decoration: InputDecoration(
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
            Text(widget.selectedDate.toString().substring(0, 10),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: blueColor,
                )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  editTaskPressed();
                },
                child: const Text("save").tr())
          ],
        ),
      ),
    );
  }

  editTaskPressed() {
    widget.task.title = widget.titleController.text;
    widget.task.description = widget.descriptionController.text;
    // widget.task.id = FirebaseAuth.instance.currentUser!.uid;
    // widget.task.id = "";
    FirebaseManager.editTask(widget.task);
    Navigator.pop(context);
  }
}
