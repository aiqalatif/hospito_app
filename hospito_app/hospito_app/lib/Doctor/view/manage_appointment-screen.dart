import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospito_app/Doctor/view/send_result_screen.dart';
import '../../Services/database_services.dart';
import '../Model/appointments_model.dart';
import '../Services/services.dart';

class ManageAppointmentScreen extends StatelessWidget {
  const ManageAppointmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Manage your appointments',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: Services().getAllAppointments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Container(
                        height: 100,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  List<AppointmentModel> appointments = [];
                  var listData = snapshot.data!.docs;
                  for (var item in listData) {
                    AppointmentModel model = AppointmentModel(
                      nodeId: item.id,
                      uid: item.get('Uid'),
                      doctorConsultation: item.get('Doctor Consultation'),
                      labName: item.get('Lab Name'),
                      phoneNumber: item.get('Patient Phone Number'),
                      address: item.get('Address'),
                      fName: item.get('Father Name'),
                      gender: item.get('Gender'),
                      name: item.get('Name'),
                      age: item.get('Age'),
                      testType: item.get('Test Type'),
                      docName: item.get('Doctor Name'),
                      time: item.get('Date Time'),
                    );
                    appointments.add(model);
                  }
                  if (appointments.length == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'No available Appointments',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: appointments.length,
                      itemBuilder: (context, i) {
                        String? a;
                        if (appointments[i].time != null &&
                            appointments[i].time.length > 0) {
                          a = appointments[i]
                              .time
                              .substring(0, appointments[i].time.length - 7);
                        }
                        return InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return SendResultScreen(
                                  pName: appointments[i].name,
                                  pFName: appointments[i].fName,
                                  pNumber: appointments[i].phoneNumber,
                                  pAge: appointments[i].age,
                                  uid: appointments[i].uid,
                                  labName: appointments[i].labName,
                                  testType: appointments[i].testType,
                                  docName: appointments[i].docName,
                                  docConsultation:
                                      appointments[i].doctorConsultation);
                            }));
                          },
                          onLongPress: () {
                            AlertDialog alert = AlertDialog(
                              title: Text("Warning"),
                              content:
                                  Text("Do you want to delete the appointment"),
                              actions: [
                                InkWell(
                                  onTap: () {
                                    Services()
                                        .deleteApp(appointments[i].nodeId);
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'You have an appointment with ${appointments[i].name} at ${appointments[i].labName}.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Timings: $a',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  Text(
                                    'Patient Phone Number:  ${appointments[i].phoneNumber}',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  Text(
                                    appointments[i].doctorConsultation == 'Yes'
                                        ? 'Doctor consultation of test result is required'
                                        : 'Doctor consultation of test result is not required',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                })
          ],
        ),
      ),
    );
  }
}
