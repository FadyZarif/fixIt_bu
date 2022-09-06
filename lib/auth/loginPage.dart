import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserCredential? userCredential;
  List userData = [];
  TextEditingController? myID = new TextEditingController();
  TextEditingController? myPassword = new TextEditingController();

  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  send() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "${myID!.text}@feng.bu.edu.eg",
          password: "${myPassword!.text}",
        );
        await AwesomeDialog(
                context: context,
                dialogType: DialogType.SUCCES,
                animType: AnimType.BOTTOMSLIDE,
                title: 'تم نسجيل الدخول بنجاح',
                autoHide: Duration(milliseconds: 1500))
            .show();

        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) {
          userData.add(value.data());
        });
        if (userData[0]['Role'] == 'Student') {
          Navigator.of(context).pushReplacementNamed("userHomePage");
        } else if (userData[0]['Role'] == 'Admin') {
          Navigator.of(context).pushReplacementNamed("adminHomePage");
        } else {
          Navigator.of(context).pushReplacementNamed("techHomePage");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'user-not-found',
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
          ).show();
        } else if (e.code == 'wrong-password') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Wrong password provided for that user.',
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
      } else if (myPassword!.text.isEmpty || myPassword!.text.length < 6) {
        return AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Enter Correct Password',
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
                  margin: EdgeInsets.all(1),
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
                      Divider(
                        color: Color(0xffffffff),
                        height: 40,
                      ),
                      MaterialButton(
                        onPressed: send,
                        child: Text(
                          "سجل الدخول",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Color(0xff2986cc),
                        elevation: 15,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        minWidth: 300,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ],
                  ))
            ],
          ),
        ]));
  }
}
