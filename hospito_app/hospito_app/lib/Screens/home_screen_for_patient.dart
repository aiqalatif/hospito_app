import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../Models/lab_model.dart';
import '../Services/database_services.dart';
import 'lab_detailed_screen.dart';

class HomeScreenForPatient extends StatefulWidget {
  const HomeScreenForPatient({Key? key}) : super(key: key);

  @override
  _HomeScreenForPatientState createState() => _HomeScreenForPatientState();
}

class _HomeScreenForPatientState extends State<HomeScreenForPatient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              children: [
                Text(
                  'Available Laboratories',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                SizedBox(height: 40),
                StreamBuilder<QuerySnapshot>(
                    stream: DatabaseServices().getLabsList(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Container(
                            height: 100,
                            child: Lottie.asset('assets/heart.json'),
                          ),
                        );
                      }
                      List labs = [];
                      var listData = snapshot.data!.docs;
                      for (var item in listData) {
                        LabModel model = LabModel(
                            number: item.get('Phone Number'),
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
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return LabDetailedScreen(
                                    labName: labs[i].labName,
                                    docName: labs[i].docName,
                                    address: labs[i].address,
                                    labId: labs[i].labId,
                                    phoneNumber: labs[i].number,
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
                Container(
                  height: 300,
                  child: Lottie.asset('assets/docter.json'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
