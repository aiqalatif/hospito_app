import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../Models/appointment_model.dart';
import '../Services/auth_services.dart';
import '../Services/database_services.dart';
import 'appointments_detailed_screen.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: Column(
            children: [
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                  stream: DatabaseServices()
                      .getAppointmentsList(AuthServices().getUid()),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Container(
                          height: 100,
                          child: Lottie.asset('assets/heart.json'),
                        ),
                      );
                    }

                    List appointments = [];
                    var listData = snapshot.data!.docs;
                    for (var item in listData) {
                      AppointmentModel model = AppointmentModel(
                          nodeId: item.id,
                          labName: item.get('Lab Name'),
                          phoneNumber: item.get('Phone Number'),
                          address: item.get('Address'),
                          fName: item.get('Father Name'),
                          gender: item.get('Gender'),
                          name: item.get('Name'),
                          age: item.get('Age'),
                          testType: item.get('Test Type'),
                          docName: item.get('Doctor Name'),
                          time: item.get('Date Time'),
                          uid: item.get('Uid'));
                      appointments.add(model);
                    }
                    if (appointments.length == 0) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'No Appointments, please wait for Admin response',
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
                                return AppointmentDetailedScreen(
                                    labName: appointments[i].labName,
                                    phoneNumber: appointments[i].phoneNumber,
                                    address: appointments[i].address,
                                    fName: appointments[i].fName,
                                    gender: appointments[i].gender,
                                    name: appointments[i].name,
                                    age: appointments[i].age,
                                    testType: appointments[i].testType,
                                    docName: appointments[i].docName,
                                    time: a!);
                              }));
                            },
                            onLongPress: () {
                              AlertDialog alert = AlertDialog(
                                title: Text("Warning"),
                                content: Text(
                                    "Do you want to delete the appointment"),
                                actions: [
                                  InkWell(
                                    onTap: () {
                                      DatabaseServices().deleteAppointment(
                                          appointments[i].nodeId,
                                          appointments[i].uid);
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
                                      'You have to take ${appointments[i].testType} at ${appointments[i].labName}.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Timings: $a',
                                      style: TextStyle(color: Colors.blue),
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
