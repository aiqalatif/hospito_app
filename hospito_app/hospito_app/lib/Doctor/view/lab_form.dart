import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:hospito_app/Components/text_field.dart';
import '../../Components/auth_button.dart';
import '../../Nearby/location_model.dart';
import '../../Nearby/location_services.dart';
import '../../Services/database_services.dart';

class LabForm extends StatefulWidget {
  const LabForm({Key? key}) : super(key: key);

  @override
  _LabFormState createState() => _LabFormState();
}

class _LabFormState extends State<LabForm> {
  final _formKey = GlobalKey<FormState>();
  String? labName;
  String? address;
  String? doctor;
  String? phoneNumber;
  bool check = false;
  @override
  Widget build(BuildContext context) {
    return check
        ? Scaffold(
            body: Center(
              child: Container(
                height: 200,
                child: Lottie.asset('assets/heart.json'),
              ),
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'Add your laboratory details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 21,
                        ),
                        CustomTextField(
                          hintText: 'Lab Name',
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Lab name';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            labName = val;
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CustomTextField(
                          hintText: 'Lab Address',
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Lab address';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            address = val;
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CustomTextField(
                          hintText: 'Doctor Name',
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Doctor Name';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            doctor = val;
                          },
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          keyBoardType: TextInputType.phone,
                          hintText: 'Lab Phone Number',
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Lab Phone Number';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            phoneNumber = val;
                          },
                        ),
                        SizedBox(height: 30),
                        AuthButton(
                            title: 'Submit',
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  setState(() {
                                    check = true;
                                  });
                                  List position = await getLabLocation();
                                  await DatabaseServices().addLabToDatabase(
                                    labName!,
                                    address!,
                                    doctor!,
                                    phoneNumber!,
                                    position,
                                  );
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                      msg: "Lab added successfully",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } catch (e) {
                                  setState(() {
                                    check = false;
                                  });
                                }
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

Future getLabLocation() async {
  List position = [];
  LocationModel model = await LocationServices().getCurrentLocation();
  position.add({
    'Latitude': model.latitude.toString(),
    'Longitude': model.longitude.toString()
  });
  return position;
}
