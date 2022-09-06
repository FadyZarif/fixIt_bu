import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditRequestPage extends StatefulWidget {
  final docid;
  final docList;

  const EditRequestPage({Key? key, this.docid, this.docList}) : super(key: key);
  @override
  State<EditRequestPage> createState() => _EditRequestPageState();
}

class _EditRequestPageState extends State<EditRequestPage> {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  late TextEditingController details =
      new TextEditingController(text: "${widget.docList["Details"]}");
  late var branch = widget.docList['Branch'],
      building = widget.docList['Building'];
  late var type = widget.docList['Type'], symbol = widget.docList['Room'],floor = widget.docList['Floor'],subType = widget.docList['subType'],imgUrl = widget.docList['imgUrl'];
  List userData = [];
  User? user = FirebaseAuth.instance.currentUser;
  int subTypeIndex=2,floorIndex=0;
  List<List> subTypeList = [
    ['اعطال اضائه ','فيش ','وصلات كهربا ','احمال تكيفات ','قاطع في لوحه ','عدم وجود مصدر كهرباء '],
    ['عدم وجود مصدر كهرباء ','ضعف ','توصيل ','كابلات '],
    ['لا يوجد'],
    ['انقطاع تيار','مفيش بروده','لا يعمل'],
    ['تسريب مياه ','كسر حنفية','وصلات مياه','انسداد صرف '],
    ['تركيب كالون','تركيب قلب ','خلع  باب  ','كسر باب ','تركيب رزه ','كسر بنش ','مشكلة سبورة '],
    ['كسر ','تركيب شبابيك الوميتال ','تركيب زجاج '],
  ];
  List<List> floorList = [
    ['0','1','2','3','4','5','6','7','8'],
    ['0','1','2','3','4'],
  ];

  bool isSubType = true;
  PlatformFile? pickedFile;
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





  edit() {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
        if (branchValidation()) {
      } else if (typeValidation()) {
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.QUESTION,
          animType: AnimType.BOTTOMSLIDE,
          title: 'هل انت متاكد من تعديل المشكلة',
          btnCancelOnPress: () {},
          btnCancelText: "الغاء",
          btnCancelIcon: Icons.close,
          btnOkIcon: Icons.done,
          btnOkText: "نعم,عدل",
          btnOkOnPress: () {
            problemRef.doc(widget.docid).update({
              "Branch": "$branch",
              "Type": "$type",
              "subType": subType??null,
              "Building": building??null,
              "Floor": floor??null,
              "Room": symbol??null,
              "EditorId": "${user!.uid}",
              "EditorName": "${userData[0]['Name']}",
              "Details": "${details.text}"
            });
          },
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تعديل الطلب"),
        centerTitle: true,
        backgroundColor: Color(0xff2986cc),
      ),
      body: Container(
        color: Colors.grey.withOpacity(0.2),
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2, color: const Color(0xffffffff)),
                  color: Color(0xffffffff)),
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
                        title: Text("الخلفاوي",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontSize: 18)),
                        activeColor: Color(0xff2986cc),
                        selected: branch == "الخلفاوي",
                        secondary: Icon(Icons.apartment),
                        value: "الخلفاوي",
                        groupValue: branch,
                        onChanged: (val) {
                          setState(() {
                            branch = val;
                          });
                        }),
                    RadioListTile(
                        title: Text("روض الفرج",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontSize: 18)),
                        activeColor: Color(0xff2986cc),
                        selected: branch == "روض الفرج",
                        tileColor: Colors.black.withOpacity(0.2),
                        selectedTileColor: Color(0xff2986cc),
                        secondary: Icon(Icons.apartment),
                        value: "روض الفرج",
                        groupValue: branch,
                        onChanged: (val) {
                          setState(() {
                            branch = val;
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
                          if(a=="كهرباء"){
                            subTypeIndex = 0;
                            isSubType = true;
                          }
                          else if(a=="النت"){
                            subTypeIndex = 1;
                            isSubType = true;
                          }
                          else if(a=="تكييفات"){
                            subTypeIndex = 3;
                            isSubType = true;
                          }
                          else if(a=="سباكة"){
                            subTypeIndex = 4;
                            isSubType = true;
                          }
                          else if(a=="نجارة"){
                            subTypeIndex = 5;
                            isSubType = true;
                          }
                          else if(a=="زجاج"){
                            subTypeIndex =6;
                            isSubType = true;
                          }
                          else{
                            //subTypeIndex =2;
                            isSubType = false;
                          }

                        });
                      },
                      value: type,
                      menuMaxHeight: 300,
                      borderRadius: BorderRadius.circular(20),

                    ),
                    SizedBox(
                      height: 20,
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
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
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
                            floorIndex=0;
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
                            floorIndex=1;
                            floor=null;
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
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        ": القاعة",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    DropdownButton(
                      isExpanded: true,
                      dropdownColor: Color(0xff2986cc),
                      hint: Text(
                        "اختر النوع",
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
                                    style: TextStyle(
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
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        ": الوصف",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    TextFormField(
                      controller: details,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      style:
                          TextStyle(fontSize: 18, color: Color((0xff2986cc))),
                      decoration: const InputDecoration(
                        hintText: "ادخل التفاصيل",
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(fontSize: 18, color: Colors.black),
                        filled: true,
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Color((0xff2986cc))),
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
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
              child: MaterialButton(
                onPressed: () {
                  edit();
                },
                child: Text(
                  "تعديل",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                color: Color((0xff2986cc)),
                padding: EdgeInsets.all(10),
                elevation: 15,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
