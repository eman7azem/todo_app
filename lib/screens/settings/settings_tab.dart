import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../shared/network/firebase/firebase_manager.dart';
import '../login/login.dart';

List<String> list = ["English", "اللغه العربيه"];

class SettingTab extends StatefulWidget {
  const SettingTab({super.key});

  @override
  State<SettingTab> createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  @override
  Widget build(BuildContext context) {
    String dropdownValue =
        context.locale.languageCode == ("ar") ? list[1] : list.first;

    // var user = getUser();
    return Padding(
      padding: const EdgeInsets.only(bottom: 100, left: 22, right: 30),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 25,
          ),
          Text(
            "language".tr(),
            style: const TextStyle(fontSize: 35),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButton(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            underline: Container(
              height: 2,
              color: Colors.black,
            ),
            onChanged: (value) {
              if (value == "English") {
                context.setLocale(const Locale("en", "US"));
              } else {
                context.setLocale(const Locale("ar", "EG"));
              }

              setState(() {
                dropdownValue = value!;
                print(dropdownValue);
                print(value);
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 100,
          ),
          FutureBuilder(
              future: getUser(),
              builder: (context, snapshot) {
                var user = snapshot.data;
                return Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text("user name : ${user?.name ?? " "}"),
                      const SizedBox(
                        height: 20,
                      ),
                      Text("user age : ${user?.age.toString() ?? " "}"),
                      const SizedBox(
                        height: 20,
                      ),
                      Text("user email : ${user?.email ?? " "}"),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              }),
          ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.routeName, (route) => false);
              },
              child: Row(
                children: [
                  const Text("logOut").tr(),
                  const Spacer(),
                  const Icon(Icons.logout),
                ],
              )),
        ],
      ),
    );
  }

  Future<UserModel?> getUser() async {
    User? fireBaseUser = FirebaseAuth.instance.currentUser;
    UserModel? userModel = await FirebaseManager.readUser(fireBaseUser!.uid);
    return userModel;
  }
}
