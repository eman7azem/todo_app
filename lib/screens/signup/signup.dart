import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/login/login.dart';

import '../../shared/network/firebase/firebase_manager.dart';

class SignUp extends StatelessWidget {
  static const routName = "Signup";
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(18),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'email'.tr()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email'.tr();
                }
                final bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (!emailValid) {
                  return "please enter valid email";
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Confirm Email'.tr()),
              validator: (value) {
                if (value != emailController.text) {
                  return 'email does not match'.tr();
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'.tr()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password'.tr();
                }
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'.tr()),
              validator: (value) {
                if (value != passwordController.text) {
                  return 'password does not match'.tr();
                }
              },
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'name'.tr()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name'.tr();
                }
              },
            ),
            TextFormField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'age'.tr()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age'.tr();
                }
                final bool ageValid = RegExp(r'^[0-9_.]+$').hasMatch(value);
                if (!ageValid) {
                  return "age not valid".tr();
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  FirebaseManager.createAccount(
                      nameController.text,
                      int.parse(ageController.text),
                      emailController.text,
                      passwordController.text, () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.routeName, (route) => false);
                    // Navigator.pushAndRemoveUntil(context, LoginScreen.routeName,(route) => false);
                  }, (errorMessage) {
                    return showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("error".tr()),
                            content: Text(
                              errorMessage.toString(),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("ok".tr()),
                              )
                            ],
                          );
                        });
                  });
                }
              },
              child: Text('signUp'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
