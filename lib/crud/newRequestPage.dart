import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NewRequestPage extends StatefulWidget {
  const NewRequestPage({Key? key}) : super(key: key);

  @override
  State<NewRequestPage> createState() => _NewRequestPageState();
}

class _NewRequestPageState extends State<NewRequestPage> {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  //TextEditingController floor = new TextEditingController();
  TextEditingController number = new TextEditingController();
  TextEditingController details = new TextEditingController();
  var branch, building;
  var type, symbol, floor, imgUrl;
  String? subType;
  List userData = [];
  User? user = FirebaseAuth.instance.currentUser;
  int subTypeIndex = 2, floorIndex = 0;
  List<List> subTypeList = [
    [
      'اعطال اضائه',
      'فيش',
      'وصلات كهربا',
      'احمال تكيفات',
      'قاطع في لوحه',
      'عدم وجود مصدر كهرباء'
    ],
    ['عدم وجود مصدر كهرباء', 'ضعف', 'توصيل', 'كابلات'],
    ['لا يوجد'],
    ['انقطاع تيار', 'مفيش بروده', 'لا يعمل'],
    ['تسريب مياه', 'كسر حنفية', 'وصلات مياه', 'انسداد صرف'],
    [
      'تركيب كالون',
      'تركيب قلب',
      'خلع  باب',
      'كسر باب',
      'تركيب رزه',
      'كسر بنش',
      'مشكلة سبورة'
    ],
    ['كسر', 'تركيب شبابيك الوميتال', 'تركيب زجاج'],
  ];
  List<List> floorList = [
    ['0', '1', '2', '3', '4', '5', '6', '7', '8'],
    ['0', '1', '2', '3', '4'],
  ];
  bool isSubType = false;

  PlatformFile? pickedFile;
  var url;

  Future uploadImagesCamera() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  getData() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      userData.add(value.data());
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  CollectionReference problemRef =
      FirebaseFirestore.instance.collection("problems");

  branchValidation() {
    if (branch == null) {
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

  typeValidation() {
    if (type == null) {
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

  // buildingValidation() {
  //   if (building == null) {
  //     return AwesomeDialog(
  //       context: context,
  //       dialogType: DialogType.ERROR,
  //       animType: AnimType.BOTTOMSLIDE,
  //       title: 'خطأ',
  //       desc: 'اختر المبني',
  //       btnOkOnPress: () {},
  //     ).show();
  //   }
  //   return false;
  // }

  // symbolValidation() {
  //   if (symbol == null) {
  //     return AwesomeDialog(
  //       context: context,
  //       dialogType: DialogType.ERROR,
  //       animType: AnimType.BOTTOMSLIDE,
  //       title: 'خطأ',
  //       desc: 'ادخل نوع القاعة',
  //       btnOkOnPress: () {},
  //     ).show();
  //   }
  //   return false;
  // }

  send() {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      // if (buildingValidation()) {
      // }
      if (branchValidation()) {
      } else if (typeValidation()) {
      }
      //  else if (symbolValidation()) {
      // }
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
          btnOkOnPress: () async {
            if (pickedFile != null) {
              final path = 'problemImages/${pickedFile!.name}';
              final file = File(pickedFile!.path!);
              final ref = FirebaseStorage.instance.ref().child(path);
              await ref.putFile(file);
              url = await ref.getDownloadURL();
            } else {
              url = null;
            }
            await problemRef
                .doc('${new DateTime.now().millisecondsSinceEpoch}')
                .set({
              "Branch": "$branch",
              "Type": "$type",
              "subType": subType ?? null,
              "Building": building ?? null,
              "Floor": floor ?? null,
              "Room": symbol ?? null,
              "SenderId": "${user!.uid}",
              "Sender": "${userData[0]['Name']}",
              "SenderIdNum": "${userData[0]['Id']}",
              "Status": "جار",
              "Details": "${details.text}",
              "Date":
                  "${DateTime.now().year}-0${DateTime.now().month}-${DateTime.now().day}",
              "Technical": [],
              "TechnicalId": " ",
              "Track": " ",
              "Request_num": "${new DateTime.now().millisecondsSinceEpoch}",
              "fixTime": null,
              "imgUrl": url
            });

            await AwesomeDialog(
                    context: context,
                    dialogType: DialogType.SUCCES,
                    animType: AnimType.BOTTOMSLIDE,
                    title: "تم اضافت طلبك بنجاح",
                    autoHide: const Duration(milliseconds: 1500))
                .show();
            if (userData[0]['Role'] == 'Student') {
              Navigator.of(context).pushReplacementNamed("userHomePage");
            } else if (userData[0]['Role'] == 'Admin') {
              Navigator.of(context).pushReplacementNamed("adminHomePage");
            } else {
              Navigator.of(context).pushReplacementNamed("techHomePage");
            }
          },
        ).show();
      }
    } else {
      if (number.text.isEmpty) {
        return AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'خطأ',
          desc: 'ادخل تفاصيل القاعة',
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff2986cc),
          title: const Text("اضافة طلب جديد"),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.grey.withOpacity(0.2),
          child: ListView(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(width: 2, color: const Color(0xffffffff)),
                    color: const Color(0xffffffff)),
                child: Form(
                  key: formstate,
                  child: Column(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        ": اختر الفرع",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      RadioListTile(
                          title: const Text("الخلفاوي",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 18)),
                          activeColor: const Color(0xff2986cc),
                          selected: branch == "الخلفاوي",
                          tileColor: Colors.black.withOpacity(0.2),
                          secondary: const Icon(Icons.apartment),
                          value: "الخلفاوي",
                          groupValue: branch,
                          onChanged: (val) {
                            setState(() {
                              branch = val;
                              print(branch);
                            });
                          }),
                      RadioListTile(
                          title: const Text("روض الفرج",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 18)),
                          activeColor: const Color(0xff2986cc),
                          selected: branch == "روض الفرج",
                          tileColor: Colors.black.withOpacity(0.2),
                          selectedTileColor: const Color(0xff2986cc),
                          secondary: const Icon(Icons.apartment),
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
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      DropdownButton(
                        dropdownColor: const Color(0xff2986cc),
                        isExpanded: true,
                        hint: const Text(
                          "اختر النوع",
                          style: TextStyle(fontSize: 18),
                        ),
                        items: [
                          "كهرباء",
                          "النت",
                          "ماكينة التصوير",
                          "تكييفات",
                          "طابعة",
                          "سباكة",
                          "نجارة",
                          "حدادة",
                          "معماري",
                          "زجاج",
                          "أخرى"
                        ]
                            .map((e) => DropdownMenuItem(
                                  child: Text("$e",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff000000),
                                      )),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (a) {
                          subType = null;
                          setState(() {
                            type = "$a";
                            if (a == "كهرباء") {
                              subTypeIndex = 0;
                              isSubType = true;
                            } else if (a == "النت") {
                              subTypeIndex = 1;
                              isSubType = true;
                            } else if (a == "تكييفات") {
                              subTypeIndex = 3;
                              isSubType = true;
                            } else if (a == "سباكة") {
                              subTypeIndex = 4;
                              isSubType = true;
                            } else if (a == "نجارة") {
                              subTypeIndex = 5;
                              isSubType = true;
                            } else if (a == "زجاج") {
                              subTypeIndex = 6;
                              isSubType = true;
                            } else {
                              //subTypeIndex =2;
                              isSubType = false;
                            }
                          });
                        },
                        value: type,
                        menuMaxHeight: 300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      Visibility(
                        visible: isSubType,
                        child: DropdownButton(
                          dropdownColor: const Color(0xff2986cc),
                          isExpanded: true,
                          hint: const Text(
                            "تحديد المشكلة",
                            style: TextStyle(fontSize: 18),
                          ),
                          items: subTypeList[subTypeIndex]
                              .map((e) => DropdownMenuItem(
                                    child: Text("$e",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff000000),
                                        )),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (a) {
                            setState(() {
                              subType = "$a";
                            });
                          },
                          value: subType,
                          menuMaxHeight: 300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Text(
                          ": اختر المبني",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      RadioListTile(
                          title: const Text("المبني الرئيسي",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 18)),
                          activeColor: const Color(0xff2986cc),
                          selected: building == "المبني الرئيسي",
                          tileColor: Colors.black.withOpacity(0.5),
                          secondary: const Icon(Icons.apartment),
                          value: "المبني الرئيسي",
                          groupValue: building,
                          onChanged: (val) {
                            setState(() {
                              building = val;
                              floorIndex = 0;
                            });
                          }),
                      RadioListTile(
                          title: const Text("المبني الفرعي",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 18)),
                          activeColor: const Color(0xff2986cc),
                          selected: building == "المبني الفرعي",
                          tileColor: Colors.black.withOpacity(0.5),
                          selectedTileColor: const Color(0xff2986cc),
                          secondary: const Icon(Icons.apartment),
                          value: "المبني الفرعي",
                          groupValue: building,
                          onChanged: (val) {
                            setState(() {
                              building = val;
                              floorIndex = 1;
                              floor = null;
                            });
                          }),
                      const Text(
                        ": الطابق",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      DropdownButton(
                        dropdownColor: const Color(0xff2986cc),
                        isExpanded: true,
                        hint: const Text(
                          "اختر الطابق",
                          style: TextStyle(fontSize: 18),
                        ),
                        items: floorList[floorIndex]
                            .map((e) => DropdownMenuItem(
                                  child: Text("$e",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff000000),
                                      )),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (a) {
                          setState(() {
                            floor = "$a";
                          });
                        },
                        value: floor,
                        menuMaxHeight: 300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      // TextFormField(
                      //   controller: floor,
                      //   textDirection: TextDirection.rtl,
                      //   maxLines: 1,
                      //   cursorColor: Color(0xff2986cc),
                      //   maxLength: 1,
                      //   autovalidateMode: AutovalidateMode.onUserInteraction,
                      //   keyboardType: TextInputType.numberWithOptions(
                      //       decimal: true, signed: false),
                      //   style:
                      //       TextStyle(fontSize: 18, color: Color(0xff2986cc)),
                      //   decoration: const InputDecoration(
                      //     hintText: "ادخل الطابق",
                      //     hintTextDirection: TextDirection.rtl,
                      //     hintStyle:
                      //         TextStyle(fontSize: 18, color: Colors.black),
                      //     filled: true,
                      //     focusColor: Color(0xff2986cc),
                      //     counterStyle: TextStyle(color: Colors.black),
                      //     border: OutlineInputBorder(),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderSide:
                      //           BorderSide(width: 2, color: Color(0xff2986cc)),
                      //     ),
                      //   ),
                      //   textInputAction: TextInputAction.next,
                      //   validator: (text) {
                      //     if (text!.isEmpty) {
                      //       return "لا يمكن ان يكون فارغاً";
                      //     }
                      //     return null;
                      //   },
                      // ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Text(
                          ": القاعة",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      DropdownButton(
                        menuMaxHeight: 300,
                        isExpanded: true,
                        dropdownColor: const Color(0xff2986cc),
                        hint: const Text(
                          "اختر القاعة",
                          style: TextStyle(fontSize: 18),
                        ),
                        items: [
                          "0",
                          "SB1-1",
                          "SB1-2",
                          "SB1-3",
                          "SB1-4",
                          "SB1-5",
                          "SB1-6",
                          "SB1-7",
                          "SB1-8",
                          "SB2-1",
                          "SB2-2",
                          "SB2-3",
                          "SB2-4",
                          "SB2-5",
                          "SB2-6",
                          "SB2-7",
                          "SB2-8",
                          "SB3-1",
                          "SB3-2",
                          "SB3-3",
                          "SB3-4",
                          "SB3-5",
                          "SB3-6",
                          "SB3-7",
                          "SB3-8",
                          "SB4-1",
                          "SB4-2",
                          "SB4-3",
                          "SB4-4",
                          "SB4-5",
                          "SB4-6",
                          "SB4-7",
                          "SB4-8",
                        ]
                            .map((e) => DropdownMenuItem(
                                  child: Text("$e",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff000000),
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
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Text(
                          ": (اختياري) الوصف",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      TextFormField(
                        controller: details,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                            fontSize: 18, color: Color(0xff2986cc)),
                        decoration: const InputDecoration(
                          hintText: "ادخل التفاصيل",
                          hintTextDirection: TextDirection.rtl,
                          hintStyle:
                              TextStyle(fontSize: 18, color: Colors.black),
                          filled: true,
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xff2986cc)),
                          ),
                        ),
                        textDirection: TextDirection.rtl,
                        textInputAction: TextInputAction.next,
                        maxLines: 8,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            onPressed: () async {
                              await uploadImagesCamera();
                            },
                            child: Icon(Icons.photo),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (pickedFile != null)
                        Visibility(
                          visible: pickedFile != null,
                          child: Container(
                              width: double.infinity,
                              color: Colors.blue[100],
                              child: Image.file(
                                File(pickedFile!.path!),
                                fit: BoxFit.cover,
                              )),
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                child: MaterialButton(
                  onPressed: () {
                    send();
                  },
                  child: const Text(
                    "ارسال",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  color: const Color(0xff2986cc),
                  padding: const EdgeInsets.all(10),
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              )
            ],
          ),
        ));
  }
}
