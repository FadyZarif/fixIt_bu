import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}



class _UserProfilePageState extends State<UserProfilePage> {

  DocumentReference userRef = FirebaseFirestore.instance.collection("users")
      .doc("${FirebaseAuth.instance.currentUser!.uid}");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("الصفحة الشخصية"),
          centerTitle: true,
          backgroundColor: Color(0xff2986cc),
        ),
        body: StreamBuilder(
          stream: userRef.snapshots(),
          builder: (context,snapshot){
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
              String name = "${(snapshot.data as DocumentSnapshot)['Name']}";
              String char = '';
              for (int i=0;i<4;i++){
                char+= name[i];
              }
              // Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
             return ListView(
                padding: EdgeInsets.all(20),
                children:  [
                   CircleAvatar(
                    child: Text("${char}",style: TextStyle(fontSize: 30,color: Colors.white),),

                    radius: 50,
                    backgroundColor: Color(0xff092b40),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2 , color: const Color(0xff092b40)),
                        color: Color(0xff092b40)
                    ),
                    child: Column(
                        textDirection: TextDirection.rtl,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20,bottom: 10),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white,fontSize: 20,),
                              initialValue: "${(snapshot.data! as DocumentSnapshot)['Name']}",
                              enabled: false,
                              textDirection: TextDirection.rtl,
                              maxLines: 1,
                              readOnly: true,
                              decoration: const InputDecoration(
                                label: Text("الاسم كامل",style: TextStyle(fontSize: 20,color: Colors.white),),
                                floatingLabelAlignment: FloatingLabelAlignment.center,
                                floatingLabelStyle: TextStyle(color: Color(0xff10476a)),
                                disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff10476a))),
                                filled: true,
                                fillColor: Color(0xff092b40),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20,bottom: 10),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white,fontSize: 20,),
                              initialValue: '${(snapshot.data! as DocumentSnapshot)['Id']}',
                              enabled: false,
                              textDirection: TextDirection.rtl,
                              maxLines: 1,
                              readOnly: true,
                              decoration: const InputDecoration(
                                label: Text("الرقم التسلسلي",style: TextStyle(fontSize: 20,color: Colors.white),),
                                floatingLabelAlignment: FloatingLabelAlignment.center,
                                floatingLabelStyle: TextStyle(color: Color(0xff10476a)),
                                disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff10476a))),
                                filled: true,
                                fillColor: Color(0xff092b40),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20,bottom: 10),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white,fontSize: 20,),
                              initialValue: '${(snapshot.data as DocumentSnapshot)['Role']}',
                              enabled: false,
                              textDirection: TextDirection.rtl,
                              maxLines: 1,
                              readOnly: true,
                              decoration: const InputDecoration(
                                label: Text("الدور",style: TextStyle(fontSize: 20,color: Colors.white),),
                                floatingLabelAlignment: FloatingLabelAlignment.center,
                                floatingLabelStyle: TextStyle(color: Color(0xff10476a)),
                                disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff10476a))),
                                filled: true,
                                fillColor: Color(0xff092b40),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 80,vertical: 15),
                    child: MaterialButton(
                      onPressed: ()async{await FirebaseAuth.instance.signOut(); Navigator.of(context).pushReplacementNamed("loginPage");},
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.exit_to_app,color: Colors.white,),
                          VerticalDivider(),
                          Text("تسجيل الخروج",style: TextStyle(fontSize: 18 , color: Colors.white),),
                        ],
                      ),
                      color: Color(0xff092b40),
                      padding: EdgeInsets.all(10),
                      elevation: 15,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

                    ),
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
