import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class AssignedList extends StatefulWidget {
  final docid;

  final docList;

  const AssignedList({Key? key, this.docid, this.docList}) : super(key: key);

  @override
  State<AssignedList> createState() => _AssignedListState();
}

class _AssignedListState extends State<AssignedList> {
  CollectionReference usersRef = FirebaseFirestore.instance.collection("users");
  CollectionReference problemRef =
      FirebaseFirestore.instance.collection("problems");
  List userData = [];
  String SelectedStatus = "جار";
  final MultiSelectController<String> _controller =
      MultiSelectController(deSelectPerpetualSelectedItems: true);
  List allSelectedID = [],allSelectedName =[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed:()async{
            for(int i = 0;i<allSelectedID.length;i++){
              await usersRef.doc(allSelectedID[i]).get().then((value) => allSelectedName.add(value.get('Name')) );
            }
            AwesomeDialog(
                context: context,
                dialogType: DialogType.QUESTION,
                animType: AnimType.BOTTOMSLIDE,
                title: ' هل انت متاكد من تعين المشكلة الي ',
                btnCancelOnPress: () {},
                btnCancelText: "الغاء",
                btnCancelIcon: Icons.close,
                btnOkIcon: Icons.done,
                btnOkText: "نعم,تعيين",
                btnOkOnPress: () async {
                  await problemRef.doc(widget.docid).update(
                      {
                        "Technical": allSelectedName,
                        "TechnicalId": allSelectedID,
                        "submitForTechinalTime": '${intl.DateFormat.yMMMMd().format(DateTime.now())}, ${TimeOfDay.now().format(context).toString()}'
                      });
                  Navigator.of(context).pop();
                }
            ).show();
          },
          child: Text("عين")
      ),
      appBar: AppBar(
        title: Text("اختر المعين له"),
        centerTitle: true,
        backgroundColor: Color(0xff2986cc),
      ),
      body: StreamBuilder(
        stream: usersRef.where("Role", whereNotIn: [
          "Student",
          "Admin",
        ]).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Text("Error");
          } else if (snapshot.hasData) {
            return MultiSelectCheckList(
              onMaximumSelected: (list, string) {
                print("$list , $string");
              },
              maxSelectableCount: 3,
              textStyles: const MultiSelectTextStyles(
                  selectedTextStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              itemsDecoration: MultiSelectDecorations(
                  selectedDecoration:
                      BoxDecoration(color: Colors.blue.withOpacity(0.8))),
              listViewSettings: ListViewSettings(
                  separatorBuilder: (context, index) => const Divider(
                        height: 0,
                      )),
              controller: _controller,
              items: List.generate(
                  (snapshot.data! as QuerySnapshot).docs.length,
                  (index) => CheckListCard(
                      value: (snapshot.data as QuerySnapshot).docs[index].id,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (snapshot.data as QuerySnapshot).docs[index]
                                ['Name'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            (snapshot.data as QuerySnapshot).docs[index]['Id'],
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                      subtitle: Text(
                          (snapshot.data as QuerySnapshot).docs[index]['Role'],
                          style: TextStyle(fontSize: 16)),
                      selectedColor: Colors.white,
                      leadingCheckBox: false,
                      checkColor: Colors.blue,
                      checkBoxBorderSide: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)))),
              onChange: (allSelectedItems, selectedItem) async {
                allSelectedID = allSelectedItems;
                print("${allSelectedID},$allSelectedName ");
              },
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
