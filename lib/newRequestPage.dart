import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewRequestPage extends StatefulWidget {
  const NewRequestPage({Key? key}) : super(key: key);

  @override
  State<NewRequestPage> createState() => _NewRequestPageState();
}

class _NewRequestPageState extends State<NewRequestPage> {

  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  TextEditingController title = new TextEditingController();
  TextEditingController floor = new TextEditingController();
  TextEditingController number = new TextEditingController();
  TextEditingController details = new TextEditingController();
  var branch, building;
  var type, symbol;
  List userData=[];
  User? user = FirebaseAuth.instance.currentUser;
  getData() {
    FirebaseFirestore.instance.collection("users").doc(
        FirebaseAuth.instance.currentUser!.uid).get()
        .then((value) {
      userData.add(value.data());
    });
  }
  @override
  void initState() {
    getData();
    super.initState();
  }
  CollectionReference problemRef = FirebaseFirestore.instance.collection("problems");

  branchValidation(){
    if(branch==null){
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'خطأ',
        desc: 'اختر الفرع',
        btnOkOnPress: () {},
      ).show();
    }
    return false;
  }
  typeValidation(){
    if(type==null){
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'خطأ',
        desc: 'اختر نوع المشكلة',
        btnOkOnPress: () {},
      ).show();
    }
    return false;
  }

  buildingValidation(){
    if(building==null){
     return AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'خطأ',
        desc: 'اختر المبني',
        btnOkOnPress: () {},
      ).show();
    }
    return false;
  }
  symbolValidation(){
    if(symbol==null){
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'خطأ',
        desc: 'ادخل نوع القاعة',
        btnOkOnPress: () {},
      ).show();
    }
    return false;
  }

  send() {
    var formdata = formstate.currentState;
    if (formdata!.validate()){
      if (buildingValidation()){}
      else if (branchValidation()){}
      else if (typeValidation()){}
      else if (symbolValidation()){}
      else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.QUESTION,
          animType: AnimType.BOTTOMSLIDE,
          title: 'هل انت متاكد من ارسال المشكلة',
          btnCancelOnPress: () {},
          btnCancelText: "الغاء",
          btnCancelIcon: Icons.close,
          btnOkIcon: Icons.done,
          btnOkText: "نعم,ارسال",
          btnOkOnPress: () { problemRef.add({
            "الفرع": "$branch",
            "النوع": "$type",
            "المبني": "$building",
            "الطابق": "${floor.text}",
            "رقم القاعة": "${number.text}",
            "نوع القاعة": "$symbol",
            "العنوان": "${title.text}",
            "senderId": "${user!.uid}",
            "المرسل": "${userData[0]['Name']}",
            "الحالة": "جار",
            "التفاصيل":"${details.text}"
          });},
        ).show();

      }
  }
    else{
      if(title.text.isEmpty){
        return AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'خطأ',
          desc: 'ادخل العنوان',
          btnOkOnPress: () {},
        ).show();
      }
      if(floor.text.isEmpty){
        return AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'خطأ',
          desc: 'ادخل رقم الطابق',
          btnOkOnPress: () {},
        ).show();
      }
      if(number.text.isEmpty){
        return AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'خطأ',
          desc: 'ادخل تفاصيل القاعة',
          btnOkOnPress: () {},
        ).show();
      }
      if(details.text.isEmpty){
        return AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'خطأ',
          desc: 'ادخل تفاصيل المشكلة',
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("اضافة طلب جديد"),
        centerTitle: true,
        backgroundColor: Color(0xff092b40),

      ),
      body: ListView(
        children: [
          Container(
            height: 200,
            child: Image.asset("assets/service.png"),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2, color: const Color(0xff092b40)),
                color: Color(0xff092b40)),
            child: Form(
              key: formstate,
              child: Column(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    ": عنوان المشكلة",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  TextFormField(
                    controller: title,
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    cursorColor: Colors.red,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                    decoration: const InputDecoration(
                      hintText: "ادخل العنوان",
                      hintTextDirection: TextDirection.rtl,
                      hintStyle: TextStyle(fontSize: 18, color: Colors.black),
                      filled: true,
                      focusColor: Colors.red,
                      counterStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.red),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "لا يمكن ان يكون فارغاً";
                      }
                      return null;
                    },
                  ),
                  const Text(
                    ": اختر الفرع",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  RadioListTile(
                      title: Text("الخلفاوي",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 18)),
                      activeColor: Colors.red,
                      selected: branch == "الخلفاوي",
                      secondary: Icon(Icons.apartment),
                      value: "الخلفاوي",
                      groupValue: branch,
                      onChanged: (val) {
                        setState(() {
                          branch = val;
                          print(branch);
                        });
                      }),
                  RadioListTile(
                      title: Text("روض الفرج",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 18)),
                      activeColor: Colors.red,
                      selected: branch == "روض الفرج",
                      tileColor: Colors.greenAccent,
                      selectedTileColor: Colors.pink,
                      secondary: Icon(Icons.apartment),
                      value: "روض الفرج",
                      groupValue: branch,
                      onChanged: (val) {
                        setState(() {
                          branch = val;
                          print(branch);
                        });
                      }),
                  const Text(
                    ": نوع المشكلة",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  DropdownButton(
                    dropdownColor: Color(0xff092b40),
                    isExpanded: true,
                    hint: Text(
                      "اختر النوع",
                      style: TextStyle(fontSize: 18),
                    ),
                    items: ["كهرباء", "نظافة", "سباكة", "نجارة"]
                        .map((e) => DropdownMenuItem(
                              child: Text("$e",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                  )),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (a) {
                      setState(() {
                        type = "$a";
                      });
                    },
                    value: type,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      ": اختر المبني",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  RadioListTile(
                      title: Text("المبني الرئيسي",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 18)),
                      activeColor: Colors.red,
                      selected: building == "المبني الرئيسي",
                      secondary: Icon(Icons.apartment),
                      value: "المبني الرئيسي",
                      groupValue: building,
                      onChanged: (val) {
                        setState(() {
                          building = val;
                          print(building);
                        });
                      }),
                  RadioListTile(
                      title: Text("المبني الفرعي",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 18)),
                      activeColor: Colors.red,
                      selected: building == "المبني الفرعي",
                      tileColor: Colors.greenAccent,
                      selectedTileColor: Colors.pink,
                      secondary: Icon(Icons.apartment),
                      value: "المبني الفرعي",
                      groupValue: building,
                      onChanged: (val) {
                        setState(() {
                          building = val;
                          print(building);
                        });
                      }),
                  const Text(
                    ": الطابق",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  TextFormField(
                    controller: floor,
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    cursorColor: Colors.red,
                    maxLength: 1,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: false),
                    style: TextStyle(fontSize: 18, color: Colors.red),
                    decoration: const InputDecoration(
                      hintText: "ادخل الطابق",
                      hintTextDirection: TextDirection.rtl,
                      hintStyle: TextStyle(fontSize: 18, color: Colors.black),
                      filled: true,
                      focusColor: Colors.red,
                      counterStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.red),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "لا يمكن ان يكون فارغاً";
                      }
                      return null;
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      ": القاعة",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton(
                          isExpanded: true,
                          dropdownColor: Color(0xff092b40),
                          hint: Text(
                            "اختر النوع",
                            style: TextStyle(fontSize: 18),
                          ),
                          items: ["SB-", "NB-", "A-", "B-", "C-"]
                              .map((e) => DropdownMenuItem(
                                    child: Text("$e",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.red,
                                        )),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (a) {
                            setState(() {
                              symbol = "$a";
                            });
                          },
                          value: symbol,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: number,
                          textDirection: TextDirection.rtl,
                          maxLines: 1,
                          cursorColor: Colors.red,
                          maxLength: 2,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: true, signed: false),
                          style: TextStyle(fontSize: 18, color: Colors.red),
                          decoration: const InputDecoration(
                            hintText: "ادخل رقم القاعة",
                            hintTextDirection: TextDirection.rtl,
                            hintStyle:
                                TextStyle(fontSize: 18, color: Colors.black),
                            filled: true,
                            focusColor: Colors.red,
                            counterStyle: TextStyle(color: Colors.white),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.red),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "لا يمكن ان يكون فارغاً";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      ": الوصف",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  TextFormField(
                    controller: details,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                    decoration: const InputDecoration(
                      hintText: "ادخل التفاصيل",
                      hintTextDirection: TextDirection.rtl,
                      hintStyle: TextStyle(fontSize: 18, color: Colors.black),
                      filled: true,
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.red),
                      ),
                    ),
                    textDirection: TextDirection.rtl,
                    textInputAction: TextInputAction.next,
                    maxLines: 8,
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "لا يمكن ان يكون فارغاً";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            child: MaterialButton(
              onPressed: () {
                send();
              },
              child: Text(
                "ارسال",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              color: Color(0xff092b40),
              padding: EdgeInsets.all(10),
              elevation: 15,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          )
        ],
      ),
    );
  }
}


