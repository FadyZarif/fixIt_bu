import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class One extends StatefulWidget {
  const One({Key? key}) : super(key: key);

  @override
  State<One> createState() => _OneState();
}

class _OneState extends State<One> {
  TextEditingController? myID = new TextEditingController();
  TextEditingController? myPassword = new TextEditingController();
  TextEditingController? myName = new TextEditingController();
  CollectionReference? users = FirebaseFirestore.instance.collection('users');
  UserCredential? userCredential;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  String? selectedRole;

  send() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      try {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: "${myID!.text}@feng.bu.edu.eg",
                password: '${myPassword!.text}');
        users!.doc(userCredential!.user!.uid).set({
          'Id': "${myID!.text}",
          'Password': '${myPassword!.text}',
          'Role': '${selectedRole??'Student'}',
          'Name': '${myName!.text}',
          'ID': "${FirebaseAuth.instance.currentUser!.uid}",
          'AttempLogin' : 0
        });
        print(userCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          return AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Weak',
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
          ).show();
        } else if (e.code == 'email-already-in-use') {
          return AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            animType: AnimType.BOTTOMSLIDE,
            title: 'already-in-use',
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
          ).show();
        }
      }
    } else {
      if (myID!.text.isEmpty) {
        return AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Enter ID',
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        )..show();
      } else if (myPassword!.text.isEmpty) {
        return AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Enter Password',
          btnCancelOnPress: () {},
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("تسجيل الدخول"),
          centerTitle: true,
          backgroundColor: Color(0xff2986cc),
        ),
        body: ListView(padding: EdgeInsets.all(25), children: [
          Column(
            children: [
              Container(
                  height: 250,
                  child: Image.asset("assets/Logofix.png")),
              Form(
                  key: formstate,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: myID,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        style: TextStyle(fontSize: 18),
                        decoration: const InputDecoration(
                          hintText: "ادخل الرقم التسلسلي",
                          hintTextDirection: TextDirection.ltr,
                          hintStyle:
                              TextStyle(fontSize: 20, color: Color(0xff092b40)),
                          label: Text("ID"),
                          filled: true,
                          suffixStyle: TextStyle(fontSize: 18),
                          prefixIcon: Icon(
                            Icons.numbers,
                            size: 25,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "لا يمكن ان يكون فارغاً";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: myPassword,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardAppearance: Brightness.dark,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          hintText: "ادخل كلمة المرور",
                          hintTextDirection: TextDirection.rtl,
                          hintStyle:
                              TextStyle(fontSize: 20, color: Color(0xff092b40)),
                          label: Text("Password"),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.password,
                            size: 25,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        maxLength: 6,
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: (s) {
                          send();
                        },
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "لا يمكن ان يكون فارغاً";
                          } else if (text.length < 6) {
                            return "ادخل 6 احرف";
                          } else {
                            return null;
                          }
                        },
                      ),
                      CustomDropdownButton2(

                        icon: Icon(
                          Icons.person_rounded,
                          size: 25,
                        ),
                        buttonWidth: double.infinity,
                        buttonHeight: 70,
                        hint: 'Select Role',
                        dropdownItems: ['Admin', 'subAdmin', 'كهربائي','سباك','فني نت','نجار','حداد','فني تكييف', 'Student'],
                        value: selectedRole,
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: myName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(fontSize: 18),
                        decoration: const InputDecoration(
                          hintText: "ادخل الاسم",
                          hintTextDirection: TextDirection.ltr,
                          hintStyle:
                              TextStyle(fontSize: 20, color: Color(0xff092b40)),
                          label: Text("Name"),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.person_rounded,
                            size: 25,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "لا يمكن ان يكون فارغاً";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        onPressed: send,
                        child: Text(
                          "سجل الحساب",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Color(0xff2986cc),
                        elevation: 15,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        minWidth: 200,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      )
                    ],
                  ))
            ],
          ),
        ]));
  }
}
