import 'package:course/admin/problemsPage.dart';
import 'package:course/admin/statisticsGraph.dart';
import 'package:course/admin/usersPage.dart';
import 'package:course/auth/one.dart';
import 'package:course/user/historyPage.dart';
import 'package:course/user/userProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../crud/newRequestPage.dart';
import '../user/userProfilePage.dart';
import 'package:course/admin/problemsPage.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

int selectedPage = 2;
List<Widget> pages = [
  UserProfilePage(),
  StatisticsGraph(),
  ProblemsPage(),
  NewRequestPage(),
  UsersPage()
];

class _AdminHomePageState extends State<AdminHomePage> {
  getUser() {
    User? user = FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.perm_identity), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_outlined), label: ""),
        ],
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
        },
        currentIndex: selectedPage,
        backgroundColor: Color(0xff2986cc),
        iconSize: 30,
        selectedFontSize: 20,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        showUnselectedLabels: false,
        showSelectedLabels: true,
        fixedColor: Colors.white,
      ),
      body: pages.elementAt(selectedPage),
    );
  }
}

class pageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {},
        child: Text("One"),
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
          onPressed: () {},
          child: Text(
            "Two",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
          elevation: 15),
    );
  }
}

class PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {},
        child: Text("Tree"),
      ),
    );
  }
}
