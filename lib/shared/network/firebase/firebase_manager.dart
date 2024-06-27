import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/task_model.dart';
import '../../../models/user_model.dart';

class FirebaseManager {
  static bool existEmail = false;
  static bool weakPassword = false;
  static CollectionReference<TaskModel> getTasksCollection() {
    return FirebaseFirestore.instance
        .collection("Tasks")
        .withConverter<TaskModel>(
      fromFirestore: (snapshot, _) {
        return TaskModel.fromJson(snapshot.data()!);
      },
      toFirestore: (task, _) {
        return task.toJson();
      },
    );
  }

  static Future<void> addTask(TaskModel task) {
    var collection = getTasksCollection();
    var docRef = collection.doc();
    task.id = docRef.id;
    return docRef.set(task);
  }

  static Stream<QuerySnapshot<TaskModel>> getTasks(DateTime date) {
    return getTasksCollection()
        .orderBy('dateCreated', descending: false)
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where("date",
            isEqualTo: DateUtils.dateOnly(date).millisecondsSinceEpoch)
        .snapshots();
  }

  static Future<void> delTask(String taskID) {
    return getTasksCollection().doc(taskID).delete();
  }

  static Future<void> updateTask(TaskModel task) {
    return getTasksCollection().doc(task.id).update(task.toJson());
  }

  static Future<void> editTask(TaskModel task) async {
    return getTasksCollection().doc(task.id).update(task.toJson());
  }

  static Future<void> createAccount(String name, int age, String emailAddress,
      String password, Function onSuccess, Function onError) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      UserModel userModel = UserModel(
          id: credential.user!.uid, name: name, email: emailAddress, age: age);
      // credential.user?.sendEmailVerification();
      addUserToFireStore(userModel);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        weakPassword = true;
        print('The password provided is too weak.');
        onError(e.message);
      } else if (e.code == 'email-already-in-use') {
        existEmail = true;
        print('The account already exists for that email.');
        onError(e.message);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> login(String emailAddress, String password,
      Function onSuccess, Function onError) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      // if (credential.user!.emailVerified) {
      //   onSuccess();
      // } else {
      //   onError("Please verify you email");
      // }
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message);

      // }
    }
  }

  static CollectionReference<UserModel> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection("Users")
        .withConverter<UserModel>(
      fromFirestore: (snapshot, _) {
        return UserModel.fromJson(snapshot.data()!);
      },
      toFirestore: (task, _) {
        return task.toJson();
      },
    );
  }

  static Future<void> addUserToFireStore(UserModel user) {
    var collection = getUsersCollection();
    var docRef = collection.doc(user.id);
    return docRef.set(user);
  }

  static Future<UserModel?> readUser(String id) async {
    DocumentSnapshot<UserModel> userDoc =
        await getUsersCollection().doc(id).get();
    return userDoc.data();
  }
}
