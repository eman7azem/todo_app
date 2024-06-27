import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/network/firebase/firebase_manager.dart';

import '../models/user_model.dart';

class MyProvider extends ChangeNotifier {
  UserModel? userModel;
  User? fireBaseUser;

  MyProvider() {
    fireBaseUser = FirebaseAuth.instance.currentUser;
    if (fireBaseUser != null) {
      initUser();
    }
  }
  initUser() async {
    fireBaseUser = FirebaseAuth.instance.currentUser;
    userModel = await FirebaseManager.readUser(fireBaseUser!.uid);
    notifyListeners();
  }
}
