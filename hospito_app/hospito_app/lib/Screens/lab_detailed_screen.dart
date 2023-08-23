import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hospito_app/Screens/pick_time_slot.dart';
import 'package:lottie/lottie.dart';

import '../Components/auth_button.dart';
import 'form_screen.dart';

class LabDetailedScreen extends StatelessWidget {
  final String labName;
  final String docName;
  final String address;
  final String labId;
  final String phoneNumber;

  const LabDetailedScreen({
    Key? key,
    required this.labName,
    required this.docName,
    required this.address,
    required this.labId,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 300,
                child: Lottie.asset('assets/doctorlab.json'),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      labName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Icon(Icons.person_outline),
                        SizedBox(width: 10),
                        Text(
                          docName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        SizedBox(width: 10),
                        Text(
                          address,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(width: 10),
                        Text(
                          phoneNumber,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.1),
              AuthButton(
                  title: 'Take Appointment',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      // return FormScreen(labId: labId);
                      return PickTimeSlotForAppointment(
                        labId: labId,
                      );
                    }));
                  }),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
