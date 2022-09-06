import 'package:course/tech/techProblemsPage.dart';
import 'package:course/user/historyPage.dart';
import 'package:course/user/userProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../crud/newRequestPage.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}



Widget? titleShowed() {
  if (selectedPage == 1) {
    return Text("سجل الطلبات");
  } else if (selectedPage == 0) {
    return Text("الصفحة الشخصية");
  } else {
    return Text("اضافة طلب جديد");
  }
}

int selectedPage = 1;
List<Widget> pages = [UserProfilePage(), HistorPage(), NewRequestPage()];

class _UserHomePageState extends State<UserHomePage> {

  getUser(){
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
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.perm_identity), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_rounded), label: ""),
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
