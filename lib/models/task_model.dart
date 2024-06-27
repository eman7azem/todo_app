import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  late String id;
  late String title;
  late String description;
  late int date;
  late bool isDone;
  late Timestamp? dateCreated;

  late String userId;

  TaskModel({
    this.id = "",
    required this.title,
    required this.description,
    required this.date,
    required this.userId,
    this.isDone = false,
    this.dateCreated,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    description = json["description"];
    date = json["date"];
    userId = json["userId"];
    isDone = json["isDone"];
    dateCreated = json["dateCreated"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date,
      "userId": userId,
      "isDone": isDone,
      "dateCreated": dateCreated,
    };
  }
}
