import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course/crud/editRequestPage.dart';
import 'package:course/viewProblem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AdminRecyclerBin extends StatefulWidget {
  const AdminRecyclerBin({Key? key}) : super(key: key);

  @override
  State<AdminRecyclerBin> createState() => _AdminRecyclerBinState();
}

class _AdminRecyclerBinState extends State<AdminRecyclerBin> {
  CollectionReference deletedproblemsRef = FirebaseFirestore.instance.collection("deletedProblems");
  CollectionReference problemsRef =
  FirebaseFirestore.instance.collection("problems");
  List<Object?> problemsList = [];



  StatusColor(i) {
    if (i == 'تم') {
      return Colors.green;
    } else if (i == 'جار') {
      return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff092b40),
          title: Text("سجل المحذوفات"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                },
                icon: Icon(Icons.search))
          ],

        ),
        body: StreamBuilder(
          stream: deletedproblemsRef
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("data");
            }
            if (snapshot.hasData) {
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
                                child: Icon(Icons.recycling_outlined,size: 35),
                              )
                            ],),
                          confirmDismiss: (dirc) async{
                            AwesomeDialog(
                                context: context,
                                dialogType: DialogType.QUESTION,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'تحذير',
                                desc: 'هل انت متاكد من استعادة الطلب',
                                btnOkOnPress: () async {

                                  await  problemsRef.add((snapshot.data as QuerySnapshot).docs.reversed.toList()[i].data());
                                  deletedproblemsRef.doc((snapshot.data as QuerySnapshot).docs.reversed.toList()[i].id).delete();
                                  return true;
                                },
                                btnCancelOnPress: (){
                                  return false;
                                },
                                btnOkText: "نعم ,استعادة",
                                buttonsTextStyle: TextStyle(fontSize: 13),
                                btnOkIcon: Icons.done,
                                btnCancelText: "الغاء الاستعادة",
                                btnCancelIcon: Icons.close
                            ).show();

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
                                                      AwesomeDialog(
                                                          context: context,
                                                          dialogType: DialogType.QUESTION,
                                                          animType: AnimType.BOTTOMSLIDE,
                                                          title: 'تحذير',
                                                          desc: 'هل انت متاكد من حذف الطلب نهائيا',
                                                          btnOkOnPress: () async {
                                                            await  deletedproblemsRef.doc("${(snapshot.data as QuerySnapshot).docs.reversed.toList()[i].id}").delete();
                                                            return true;
                                                          },
                                                          btnCancelOnPress: (){
                                                            return false;
                                                          },
                                                          btnOkText: "نعم ,احذف",
                                                          btnOkIcon: Icons.done,
                                                          btnCancelText: "الغاء الحذف",
                                                          btnCancelIcon: Icons.close
                                                      ).show();

                                                    },
                                                    icon: Icon(Icons.delete_forever)),
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
                                            flex: 2,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                    "نوع : ${(snapshot.data! as QuerySnapshot).docs.reversed.toList()[i]["Type"]}",
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 14)),
                                                /*Text("التاريخ: ${problemsList[i]["date"]}",
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 14)),*/
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
                                          )
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

