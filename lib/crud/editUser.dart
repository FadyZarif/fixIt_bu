

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditUser extends StatefulWidget {
  final  userId;
  final  userList;

  const EditUser({Key? key, this.userId, this.userList}) : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {

 late TextEditingController myName = new TextEditingController(text: widget.userList['Name']);
  CollectionReference? users = FirebaseFirestore.instance.collection('users');
  UserCredential? userCredential;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  late String selectedRole = '${widget.userList['Role']}';

  send() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      try {
        users!.doc(widget.userId).update({
          'Role': '${selectedRole}',
          'Name': '${myName.text}',
        });
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
                            selectedRole = value!;
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
                          "تعديل",
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
