import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Model/test_model.dart';
import '../Services/services.dart';
import 'accepts_appointment_screen.dart';

class PendingAppointments extends StatefulWidget {
  final String labId;
  final String labName;
  final String address;
  final String doctor;
  final String phoneNumber;
  const PendingAppointments(
      {Key? key,
      required this.phoneNumber,
      required this.labId,
      required this.labName,
      required this.doctor,
      required this.address})
      : super(key: key);

  @override
  State<PendingAppointments> createState() => _PendingAppointmentsState();
}

class _PendingAppointmentsState extends State<PendingAppointments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                ),
                Text(
                  'Pending Test Appointments',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                SizedBox(height: 20),
                StreamBuilder<QuerySnapshot>(
                    stream: Services().getTestsList(widget.labId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      List tests = [];
                      var listData = snapshot.data!.docs;
                      for (var item in listData) {
                        TestModel model = TestModel(
                          phoneNumber: item.get('Phone Number'),
                          doctorConsultation: item.get('Doctor Consultation'),
                          gender: item.get('Gender'),
                          age: item.get('Age'),
                          fName: item.get('Father Name'),
                          name: item.get('Name'),
                          uid: item.get('User Id'),
                          testType: item.get('Test Type'),
                          appointmentTime: item.get('Appointment Time'),
                          docId: item.get('Doc Id'),
                        );
                        tests.add(model);
                      }
                      if (tests.length == 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'No available pending Appointment requests',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: tests.length,
                          itemBuilder: (context, i) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return AcceptAppointmentScreen(
                                    labId: widget.labId,
                                    testType: tests[i].testType,
                                    uid: tests[i].uid,
                                    name: tests[i].name,
                                    fName: tests[i].fName,
                                    age: tests[i].age,
                                    gender: tests[i].gender,
                                    labName: widget.labName,
                                    doctor: widget.doctor,
                                    address: widget.address,
                                    phoneNumber: widget.phoneNumber,
                                    doctorConsultation:
                                        tests[i].doctorConsultation,
                                    userPhoneNumber: tests[i].phoneNumber,
                                    appointmentTime: tests[i].appointmentTime,
                                    docId: tests[i].docId,
                                  );
                                }));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          offset: Offset(0, 0),
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                        )
                                      ]),
                                  child: ListTile(
                                    title: Text('Name: ${tests[i].name}'),
                                    subtitle:
                                        Text('Test type: ${tests[i].testType}'),
                                    trailing: Text('age: ${tests[i].age}'),
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
      ),
    );
  }
}
