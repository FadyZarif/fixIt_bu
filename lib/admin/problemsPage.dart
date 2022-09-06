import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course/crud/editRequestPage.dart';
import 'package:course/viewProblem.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';

class ProblemsPage extends StatefulWidget {
  const ProblemsPage({Key? key}) : super(key: key);

  @override
  State<ProblemsPage> createState() => _ProblemsPageState();
}

class _ProblemsPageState extends State<ProblemsPage> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController dateController = new TextEditingController();
  CollectionReference deletedproblemsRef =
      FirebaseFirestore.instance.collection("deletedProblems");
  var problemsRef =
      FirebaseFirestore.instance.collection("problems");
  var SelectedStatus, typeFilter, branchFilter, buildingFilter, statusFilter,timeFilter,timevalue;
  List<String> assignedToList = [];
  List<Object?> problemsList = [];



  StatusColor(i) {
    if (i == 'تم') {
      SelectedStatus = "تم";
      return Colors.green;
    } else if (i == 'جار') {
      SelectedStatus = "جار";
      return Colors.yellow;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        endDrawer: Drawer(
          child: ListView(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "ابحث",
                    style: TextStyle(fontSize: 30),
                  ),
                  Divider(thickness: 2, indent: 15, endIndent: 15),
                  SizedBox(
                    height: 40,
                  ),
                  CustomDropdownButton2(
                    hint: "اختر الفرع",
                    dropdownItems: ["الكل", "الخلفاوي", "روض الفرج"],
                    value: branchFilter,
                    onChanged: (value) {
                      setState(() {
                        if (value == "الكل") {
                          branchFilter = null;
                        } else {
                          branchFilter = value;
                        }
                      });
                    },
                    buttonWidth: 250,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  CustomDropdownButton2(
                    hint: "اختر المبني",
                    dropdownItems: ["الكل", "المبني الرئيسي", "المبني الفرعي"],
                    value: buildingFilter,
                    onChanged: (value) {
                      setState(() {
                        if (value == "الكل") {
                          buildingFilter = null;
                        } else {
                          buildingFilter = value;
                        }
                      });
                    },
                    buttonWidth: 250,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  CustomDropdownButton2(
                    hint: "اختر النوع",
                    dropdownItems: [
                      "الكل",
                      "كهربية",
                      "النت",
                      "ماكينة التصوير",
                      "تكييفات",
                      "طابعة",
                      "سباكة",
                      "نجارة",
                      "أعطال كهربية",
                      "حدادة",
                      "معماري",
                      "زجاج",
                      "أخرى"
                    ],
                    value: typeFilter,
                    onChanged: (value) {
                      setState(() {
                        if (value == "الكل") {
                          typeFilter = null;
                        } else {
                          typeFilter = value;
                        }
                      });
                    },
                    buttonWidth: 250,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  CustomDropdownButton2(
                    hint: "اختر الحالة",
                    dropdownItems: [
                      "الكل",
                      "تم",
                      "جار",
                    ],
                    value: statusFilter,
                    onChanged: (value) {
                      setState(() {
                        if (value == "الكل") {
                          statusFilter = null;
                        } else {
                          statusFilter = value;
                        }
                      });
                    },
                    buttonWidth: 250,
                  ),
                ],
              )
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Color(0xff2986cc),
          title: Text("سجل الطلبات"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    FirebaseFirestore.instance
                        .collection("users")
                        .get()
                        .then((value) {
                      value.docs.forEach((element) {
                        assignedToList.add(element.get("Name"));
                      });
                    });
                  });
                  scaffoldKey.currentState!.openEndDrawer();
                },
                icon: Icon(Icons.search))
          ],
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("adminRecyclerBin");
              },
              icon: Icon(Icons.auto_delete_outlined)),
        ),
        body: StreamBuilder (
          stream: problemsRef
              .where("Branch", isEqualTo: branchFilter)
              .where("Building", isEqualTo: buildingFilter)
              .where("Type", isEqualTo: typeFilter)
              .where("Status", isEqualTo: statusFilter)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("data");
            }
            if (snapshot.hasData) {
              //86400000 for 1 day
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, i) {
                        return Dismissible(
                          resizeDuration: const Duration(milliseconds: 650),
                          movementDuration: const Duration(milliseconds: 650),
                          background: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Icon(Icons.delete, size: 35),
                              )
                            ],
                          ),
                          confirmDismiss: (dirc) async {
                            AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.QUESTION,
                                    animType: AnimType.BOTTOMSLIDE,
                                    title: 'تحذير',
                                    desc: 'هل انت متاكد من حذف الطلب',
                                    btnOkOnPress: () async {
                                      await deletedproblemsRef.add(
                                          (snapshot.data as QuerySnapshot)
                                              .docs.reversed.toList()[i]
                                              .data());
                                      problemsRef
                                          .doc((snapshot.data as QuerySnapshot)
                                              .docs.reversed.toList()[i]
                                              .id)
                                          .delete();
                                      return true;
                                    },
                                    btnCancelOnPress: () {
                                      return false;
                                    },
                                    btnOkText: "نعم ,احذف",
                                    btnOkIcon: Icons.done,
                                    btnCancelText: "الغاء الحذف",
                                    btnCancelIcon: Icons.close)
                                .show();
                          },
                          direction: DismissDirection.endToStart,
                          key: Key("$i"),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                color:
                                    i.isEven ? Colors.white : Color(0xffc7c7c7),
                                elevation: 3,
                                shadowColor: Colors.black,
                                margin: EdgeInsets.symmetric(vertical: 7),
                                child: InkWell(
                                  splashColor: Color(0xff878787),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return ViewProblem(
                                        docid: (snapshot.data! as QuerySnapshot)
                                            .docs.reversed.toList()[i]
                                            .id,
                                        docList:
                                            (snapshot.data! as QuerySnapshot)
                                                .docs.reversed.toList()[i],
                                      );
                                    }));
                                  },
                                  child: Container(
                                      height: 150,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return EditRequestPage(
                                                          docid: (snapshot.data!
                                                                  as QuerySnapshot)
                                                              .docs.reversed.toList()[i]
                                                              .id,
                                                          docList: (snapshot
                                                                      .data!
                                                                  as QuerySnapshot)
                                                              .docs.reversed.toList()[i],
                                                        );
                                                      }));
                                                    },
                                                    icon: Icon(Icons.edit)),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  (snapshot.data!
                                                          as QuerySnapshot)
                                                      .docs.reversed.toList()[i]['Type'],
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.black87),
                                                  textDirection:
                                                      TextDirection.rtl,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Flexible(
                                                  child: RichText(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      strutStyle: StrutStyle(
                                                        fontSize: 12.0,
                                                      ),
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 16),
                                                        text:
                                                            "تفاصيل : ${(snapshot.data! as QuerySnapshot).docs.reversed.toList()[i]['Details']}",
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "المرسل: ",
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 18),
                                                      textDirection:
                                                          TextDirection.rtl,
                                                    ),
                                                    Text(
                                                      "${(snapshot.data! as QuerySnapshot).docs.reversed.toList()[i]["Sender"]}",
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 16),
                                                      textDirection:
                                                          TextDirection.rtl,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                    "فرع : ${(snapshot.data! as QuerySnapshot).docs.reversed.toList()[i]["Branch"]}",
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 14)),
                                                Text(
                                                    "التاريخ: ${(snapshot.data! as QuerySnapshot).docs.reversed.toList()[i]["Date"]}",
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 14)),
                                                Text(
                                                    "الحالة : ${(snapshot.data! as QuerySnapshot).docs.reversed.toList()[i]["Status"]}",
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 14)),
                                                Icon(
                                                  Icons.album_outlined,
                                                  color: StatusColor(
                                                      "${(snapshot.data! as QuerySnapshot).docs.reversed.toList()[i]["Status"]}"),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                PopupMenuButton(
                                                  itemBuilder: (context) =>
                                                      const [
                                                    PopupMenuItem(
                                                      enabled: false,
                                                      child: Text(
                                                        "تعيين حالة المشكلة",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blueAccent),
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                        child: Text("تم"),
                                                        value: "تم"),
                                                    PopupMenuItem(
                                                        child: Text("جار"),
                                                        value: "جار"),
                                                  ],
                                                  initialValue: SelectedStatus,
                                                  onSelected: (value) {
                                                    if (value == "تم") {
                                                      SelectedStatus = "تم";
                                                      problemsRef
                                                          .doc((snapshot.data!
                                                                  as QuerySnapshot)
                                                              .docs.reversed.toList()[i]
                                                              .id)
                                                          .update({
                                                        "Status": "تم",
                                                        "fixTime": "${DateTime.now().year}-0${DateTime.now().month}-${DateTime.now().day}"
                                                      });
                                                    } else if (value == "جار") {
                                                      SelectedStatus = "جار";
                                                      problemsRef
                                                          .doc((snapshot.data!
                                                                  as QuerySnapshot)
                                                              .docs.reversed.toList()[i]
                                                              .id)
                                                          .update({
                                                        "Status": "جار",
                                                        "fixTime": null
                                                      });
                                                    }
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                )),
                          ),
                        );
                      },
                      itemCount: (snapshot.data! as QuerySnapshot).docs.length),
                ),
              );
            }
            return AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 12),
                  Text('Loading..')
                ],
              ),
            );
          },
        ));
  }
}
