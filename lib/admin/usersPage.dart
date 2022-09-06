import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course/crud/editUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../crud/editRequestPage.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  CollectionReference usersRef = FirebaseFirestore.instance.collection("users");
  var NameSearch  ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){Navigator.of(context).pushNamed("signUp");}, icon: Icon(Icons.add_reaction_outlined))
        ],
        toolbarHeight: 120,
        title: Column(
          children: [
            Text("قائمة المستخدمين"),
            Card(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search), hintText: 'بحث...'),
                  onChanged: (val) {
                    setState(() {
                      NameSearch = val;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Color(0xff2986cc),
      ),
      body: StreamBuilder(
        stream: usersRef.where('Name',).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Text("Error");
          } else if (snapshot.hasData) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, i) {
                      String name =
                          "${(snapshot.data as QuerySnapshot).docs[i]['Name']}";
                      String char = '';
                      for (int i = 0; i < 4; i++) {
                        char += name[i];
                      }
                      var data = (snapshot.data as QuerySnapshot).docs[i].data()
                      as Map<String, dynamic>;

                      if (NameSearch == null) {
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
                                desc: 'هل انت متاكد من حذف المستخدم',
                                btnOkOnPress: () {
                                  usersRef
                                      .doc((snapshot.data as QuerySnapshot)
                                      .docs[i]
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
                                  onTap: () {},
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
                                                      Navigator.push(context, MaterialPageRoute(
                                                          builder: (context)=>
                                                              EditUser(
                                                                userId: (snapshot.data!
                                                                as QuerySnapshot)
                                                                    .docs[i]
                                                                    .id,
                                                                userList: (snapshot
                                                                    .data!
                                                                as QuerySnapshot)
                                                                    .docs[i],
                                                              )
                                                      ));
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
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  (snapshot.data!
                                                  as QuerySnapshot)
                                                      .docs[i]['Name'],
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
                                                            color: Colors
                                                                .black54,
                                                            fontSize: 16),
                                                        text:
                                                        "الرقم التسلسلي : ${(snapshot
                                                            .data! as QuerySnapshot)
                                                            .docs[i]['Id']}",
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "الدور: ",
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 18),
                                                      textDirection:
                                                      TextDirection.rtl,
                                                    ),
                                                    Text(
                                                      "${(snapshot
                                                          .data! as QuerySnapshot)
                                                          .docs[i]["Role"]}",
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
                                              MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                  Color(0xff2986cc),
                                                  radius: 35,
                                                  child: Text("$char",
                                                      style: TextStyle(
                                                          color:
                                                          Color(0xffffffff))),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                )),
                          ),
                        );
                      }
                      else if (data['Name']
                          .startsWith(NameSearch.toLowerCase())) {
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
                                desc: 'هل انت متاكد من حذف المستخدم',
                                btnOkOnPress: () {
                                  usersRef
                                      .doc((snapshot.data as QuerySnapshot)
                                      .docs[i]
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
                                  onTap: () {},
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
                                                      Navigator.of(context)
                                                          .push(
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) {
                                                                return EditRequestPage(
                                                                  docid: (snapshot
                                                                      .data!
                                                                  as QuerySnapshot)
                                                                      .docs[i]
                                                                      .id,
                                                                  docList: (snapshot
                                                                      .data!
                                                                  as QuerySnapshot)
                                                                      .docs[i],
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
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  (snapshot.data!
                                                  as QuerySnapshot)
                                                      .docs[i]['Name'],
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
                                                            color: Colors
                                                                .black54,
                                                            fontSize: 16),
                                                        text:
                                                        "الرقم التسلسلي : ${(snapshot
                                                            .data! as QuerySnapshot)
                                                            .docs[i]['Id']}",
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "الدور: ",
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 18),
                                                      textDirection:
                                                      TextDirection.rtl,
                                                    ),
                                                    Text(
                                                      "${(snapshot
                                                          .data! as QuerySnapshot)
                                                          .docs[i]["Role"]}",
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
                                              MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                  Color(0xff2986cc),
                                                  radius: 35,
                                                  child: Text("$char",
                                                      style: TextStyle(
                                                          color:
                                                          Color(0xffffffff))),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                )),
                          ),
                        );
                      }
                      return Container();
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
      ),
    );
  }
}
