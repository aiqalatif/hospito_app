import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospito_app/Doctor/view/pending_appointments.dart';
import '../Model/labs_model.dart';
import '../Services/services.dart';

class ManageLabsScreen extends StatelessWidget {
  const ManageLabsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              Text(
                'Manage Laboratories',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(height: 40),
              StreamBuilder<QuerySnapshot>(
                  stream: Services().getLabsList(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    List<LabModel> labs = [];
                    var listData = snapshot.data!.docs;
                    for (var item in listData) {
                      LabModel model = LabModel(
                          phoneNumber: item.get('Phone Number'),
                          address: item.get('Address'),
                          docName: item.get('Doctor'),
                          labName: item.get('Lab Name'),
                          labId: item.id);
                      labs.add(model);
                    }
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: labs.length,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onLongPress: () {
                              AlertDialog alert = AlertDialog(
                                title: Text("Warning"),
                                content: Text("Do you want to delete the Lab"),
                                actions: [
                                  InkWell(
                                    onTap: () {
                                      Services().deleteLab(labs[i].labId);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.red[800],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ],
                              );

                              // show the dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                            },
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PendingAppointments(
                                  labId: labs[i].labId,
                                  labName: labs[i].labName,
                                  address: labs[i].address,
                                  doctor: labs[i].docName,
                                  phoneNumber: labs[i].phoneNumber,
                                );
                              }));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        offset: Offset(0, 0),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                      )
                                    ]),
                                child: Column(
                                  children: [
                                    Text(
                                      labs[i].labName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
