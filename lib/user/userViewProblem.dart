import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course/assignedList.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class UserViewProblem extends StatefulWidget {
  final docid;
  final docList;

  const UserViewProblem({Key? key, this.docid, this.docList}) : super(key: key);

  @override
  State<UserViewProblem> createState() => _UserViewProblemState();
}


class _UserViewProblemState extends State<UserViewProblem> {

  @override
  Widget build(BuildContext context) {

    DocumentReference probRef = FirebaseFirestore.instance.collection("problems").doc("${widget.docid}");
    return Scaffold(
        appBar: AppBar(
          title: Text("تفاصيل المشكلة"),
          centerTitle: true,
          backgroundColor: Color(0xff092b40),
        ),
        body: StreamBuilder(
            stream: probRef.snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasError){
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'خطأ',
                  btnCancelOnPress: () {},
                ).show();
              }
              else  if(snapshot.hasData){
                return  ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 2, color: const Color(0xff092b40)),
                          color: Color(0xff092b40)),
                      child: Column(
                          textDirection: TextDirection.rtl,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20, bottom: 10),
                              child: TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                initialValue: "${(snapshot.data as DocumentSnapshot)['Sender']}",
                                enabled: false,
                                textDirection: TextDirection.rtl,
                                maxLines: 1,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  label: Text(
                                    "اسم المرسل",
                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                  floatingLabelAlignment: FloatingLabelAlignment.center,
                                  floatingLabelStyle:
                                  TextStyle(color: Color(0xff10476a)),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xff10476a))),
                                  filled: true,
                                  fillColor: Color(0xff092b40),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20, bottom: 10),
                              child: TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                initialValue: '${(snapshot.data as DocumentSnapshot)['Type']}',
                                enabled: false,
                                textDirection: TextDirection.rtl,
                                maxLines: 1,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  label: Text(
                                    "نوع المشكلة",
                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                  floatingLabelAlignment: FloatingLabelAlignment.center,
                                  floatingLabelStyle:
                                  TextStyle(color: Color(0xff10476a)),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xff10476a))),
                                  filled: true,
                                  fillColor: Color(0xff092b40),
                                ),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 20, bottom: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                        initialValue: '${(snapshot.data as DocumentSnapshot)['Building']}',
                                        enabled: false,
                                        textDirection: TextDirection.rtl,
                                        maxLines: 1,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          label: Text(
                                            "المبني",
                                            style: TextStyle(fontSize: 20, color: Colors.white),
                                          ),
                                          floatingLabelAlignment: FloatingLabelAlignment.center,
                                          floatingLabelStyle:
                                          TextStyle(color: Color(0xff10476a)),
                                          disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xff10476a))),
                                          filled: true,
                                          fillColor: Color(0xff092b40),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                        initialValue: '${(snapshot.data as DocumentSnapshot)['Branch']}',
                                        enabled: false,
                                        textDirection: TextDirection.rtl,
                                        maxLines: 1,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          label: Text(
                                            "الفرع",
                                            style: TextStyle(fontSize: 20, color: Colors.white),
                                          ),
                                          floatingLabelAlignment: FloatingLabelAlignment.center,
                                          floatingLabelStyle:
                                          TextStyle(color: Color(0xff10476a)),
                                          disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xff10476a))),
                                          filled: true,
                                          fillColor: Color(0xff092b40),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20, bottom: 10),
                              child: TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                initialValue: '${(snapshot.data as DocumentSnapshot)['Date']}',
                                enabled: false,
                                textDirection: TextDirection.rtl,
                                maxLines: 1,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  label: Text(
                                    "تاريخ البدء",
                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                  floatingLabelAlignment: FloatingLabelAlignment.center,
                                  floatingLabelStyle:
                                  TextStyle(color: Color(0xff10476a)),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xff10476a))),
                                  filled: true,
                                  fillColor: Color(0xff092b40),
                                ),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 20, bottom: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                        initialValue: '${(snapshot.data as DocumentSnapshot)['Room']}',
                                        enabled: false,
                                        textDirection: TextDirection.rtl,
                                        maxLines: 1,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          label: Text(
                                            "الغرفة",
                                            style: TextStyle(fontSize: 20, color: Colors.white),
                                          ),
                                          floatingLabelAlignment: FloatingLabelAlignment.center,
                                          floatingLabelStyle:
                                          TextStyle(color: Color(0xff10476a)),
                                          disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xff10476a))),
                                          filled: true,
                                          fillColor: Color(0xff092b40),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                        initialValue: '${(snapshot.data as DocumentSnapshot)['Floor']}',
                                        enabled: false,
                                        textDirection: TextDirection.rtl,
                                        maxLines: 1,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          label: Text(
                                            "الطابق",
                                            style: TextStyle(fontSize: 20, color: Colors.white),
                                          ),
                                          floatingLabelAlignment: FloatingLabelAlignment.center,
                                          floatingLabelStyle:
                                          TextStyle(color: Color(0xff10476a)),
                                          disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xff10476a))),
                                          filled: true,
                                          fillColor: Color(0xff092b40),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20, bottom: 10),
                              child: TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                initialValue: '${(snapshot.data as DocumentSnapshot)['Details']}',
                                enabled: false,
                                textDirection: TextDirection.rtl,
                                maxLines: 8,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  label: Text(
                                    "التفاصيل",
                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                  floatingLabelAlignment: FloatingLabelAlignment.center,
                                  floatingLabelStyle:
                                  TextStyle(color: Color(0xff10476a)),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xff10476a))),
                                  filled: true,
                                  fillColor: Color(0xff092b40),
                                ),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 20, bottom: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                        initialValue: '${(snapshot.data as DocumentSnapshot)['Status']}',
                                        enabled: false,
                                        textDirection: TextDirection.rtl,
                                        maxLines: 1,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          label: Text(
                                            "الحالة",
                                            style: TextStyle(fontSize: 20, color: Colors.white),
                                          ),
                                          floatingLabelAlignment: FloatingLabelAlignment.center,
                                          floatingLabelStyle:
                                          TextStyle(color: Color(0xff10476a)),
                                          disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xff10476a))),
                                          filled: true,
                                          fillColor: Color(0xff092b40),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      flex: 3,
                                      child: TextFormField(
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                        initialValue: '${(snapshot.data as DocumentSnapshot)['Technical']}',
                                        enabled: false,
                                        textDirection: TextDirection.rtl,
                                        maxLines: 1,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          label: Text(
                                            "ميعنه الي",
                                            style: TextStyle(fontSize: 20, color: Colors.white),
                                          ),
                                          floatingLabelAlignment: FloatingLabelAlignment.center,
                                          floatingLabelStyle:
                                          TextStyle(color: Color(0xff10476a)),
                                          disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xff10476a))),
                                          filled: true,
                                          fillColor: Color(0xff092b40),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20, bottom: 10),
                              child: TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                initialValue:'${(snapshot.data as DocumentSnapshot)['Track']}',
                                enabled: false,
                                textDirection: TextDirection.rtl,
                                maxLines: 8,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  label: Text(
                                    "مسار المشكلة",
                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                  floatingLabelAlignment: FloatingLabelAlignment.center,
                                  floatingLabelStyle:
                                  TextStyle(color: Color(0xff10476a)),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xff10476a))),
                                  filled: true,
                                  fillColor: Color(0xff092b40),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ],
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
                actions: [
                  TextButton(onPressed: (){Navigator.pop(context);}, child: Text('ok'))
                ],
              );
            }
        )
    );
  }
}
