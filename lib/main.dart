import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course/admin/adminHomePage.dart';
import 'package:course/admin/statisticsGraph.dart';
import 'package:course/auth/one.dart';
import 'package:course/crud/newRequestPage.dart';
import 'package:course/tech/techHomePage.dart';
import 'package:course/user/userHomePage.dart';
import 'package:course/user/userRecyclerBin.dart';
import 'package:course/user/userViewProblem.dart';
import 'package:course/viewProblem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:course/auth/loginPage.dart';

import 'admin/adminRecyclerBin.dart';

bool? isLogin;

List userData = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? user = FirebaseAuth.instance.currentUser;
  await FirebaseFirestore.instance
      .collection("users")
      .doc(user?.uid)
      .get()
      .then((value) {
    userData.add(value.data());
  });
  if (user == null) {
    isLogin = false;
  } else {
    isLogin = true;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget? selectedHome() {
      if (isLogin == true) {
        if (userData[0]['Role'] == 'Student') {
          return UserHomePage();
        } else if (userData[0]['Role'] == 'Admin') {
          return AdminHomePage();
        } else {
          return TechHomePage();
        }
      } else {
        return LoginPage();
      }
    }

    return MaterialApp(
      title: 'FixIt',
      home: selectedHome(),
      debugShowCheckedModeBanner: false,
      routes: {
        "main": (context) => MyApp(),
        "one": (context) => One(),
        "userHomePage": (context) => UserHomePage(),
        "signUp": (context) => One(),
        "loginPage": (context) => LoginPage(),
        "adminHomePage": (context) => AdminHomePage(),
        "techHomePage": (context) => TechHomePage(),
        "userRecyclerBin": (context) => UserRecyclerBin(),
        "adminRecyclerBin": (context) => AdminRecyclerBin(),
        "newRequestPage": (context) => NewRequestPage(),
        "viewProblem": (context) => ViewProblem(),
        "userViewProblem": (context) => UserViewProblem(),
        "statisticsGraph": (context) => StatisticsGraph(),
      },
    );
  }
}
