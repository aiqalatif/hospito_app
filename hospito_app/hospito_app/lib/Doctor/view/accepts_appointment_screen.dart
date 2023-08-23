import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospito_app/Services/database_services.dart';

import '../Services/services.dart';
import 'accepted_screen.dart';

class AcceptAppointmentScreen extends StatefulWidget {
  final String name;
  final String fName;
  final String age;
  final String gender;
  final String testType;
  final String uid;
  final String labName;
  final String address;
  final String doctor;
  final String phoneNumber;
  final String labId;
  final String userPhoneNumber;
  final String doctorConsultation;
  final String appointmentTime;
  final String docId;
  const AcceptAppointmentScreen(
      {Key? key,
      required this.docId,
      required this.appointmentTime,
      required this.doctorConsultation,
      required this.userPhoneNumber,
      required this.phoneNumber,
      required this.labId,
      required this.testType,
      required this.uid,
      required this.name,
      required this.fName,
      required this.age,
      required this.gender,
      required this.address,
      required this.doctor,
      required this.labName})
      : super(key: key);

  @override
  _AcceptAppointmentScreenState createState() =>
      _AcceptAppointmentScreenState();
}

class _AcceptAppointmentScreenState extends State<AcceptAppointmentScreen> {
  bool check = false;
  bool scroll = false;
  String? appointmentDate;
  @override
  Widget build(BuildContext context) {
    return scroll
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                    ),
                    Text(
                      'Patient Details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      width: double.infinity,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 0),
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 1,
                        )
                      ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${widget.name}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Father Name: ${widget.fName}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text('Age: ${widget.age}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18)),
                          SizedBox(height: 10),
                          Text('Gender: ${widget.gender}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18)),
                          SizedBox(height: 10),
                          Text('Test Type: ${widget.testType}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18)),
                          SizedBox(height: 10),
                          Text('Phone number: ${widget.userPhoneNumber}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18)),
                          SizedBox(height: 10),
                          Text(
                              'Doctor Consultation: ${widget.doctorConsultation}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18)),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'The patient requested to book appointment around\n ${widget.appointmentTime}',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kindly give the patient a specific time to come, before accepting the Appointment',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                onChanged: (date) {}, onConfirm: (date) {
                              appointmentDate = date.toString();
                              setState(() {
                                check = true;
                              });
                              print(appointmentDate);
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: check ? Colors.blue : Colors.grey,
                                  width: 2),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  check ? appointmentDate! : 'Pick date & time',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          check ? Colors.blue : Colors.black),
                                ),
                                Icon(
                                  check ? Icons.check : Icons.date_range,
                                  color: check ? Colors.blue : Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            DatabaseServices().deleteTest(
                              widget.labId,
                              widget.docId,
                            );
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: "Appointment Rejected",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          },
                          child: Container(
                            width: 70,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Center(
                                child: Text(
                                  'Reject',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              scroll = true;
                            });
                            try {
                              await Services().addAppointmentToDatabase(
                                this.widget.name,
                                this.widget.fName,
                                this.widget.age,
                                this.widget.gender,
                                this.widget.testType,
                                this.widget.uid,
                                this.widget.address,
                                this.widget.doctor,
                                this.widget.labName,
                                appointmentDate!,
                                this.widget.phoneNumber,
                              );
                              await Services().addAllAppointmentsToDatabase(
                                this.widget.name,
                                this.widget.fName,
                                this.widget.age,
                                this.widget.gender,
                                this.widget.testType,
                                this.widget.uid,
                                this.widget.address,
                                this.widget.doctor,
                                this.widget.labName,
                                appointmentDate!,
                                this.widget.userPhoneNumber,
                                this.widget.doctorConsultation,
                              );
                              await Services().deleteTheAppointment(
                                  this.widget.labId,
                                  this.widget.uid,
                                  this.widget.testType);
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return AcceptedScreen();
                              }));
                              Fluttertoast.showToast(
                                  msg: "Appointment Accepted",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } catch (e) {
                              setState(() {
                                scroll = false;
                              });
                              Fluttertoast.showToast(
                                  msg: "Network Error",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          child: Container(
                            width: 70,
                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Center(
                                child: Text(
                                  'Accept',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
