import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospito_app/Components/text_field.dart';
import 'package:hospito_app/Screens/submitted_screen.dart';
import 'package:lottie/lottie.dart';
import '../Components/auth_button.dart';
import '../Components/form_text_field.dart';
import '../Services/auth_services.dart';
import '../Services/database_services.dart';

class FormScreen extends StatefulWidget {
  final String labId;
  final String appointmentTime;
  const FormScreen({
    Key? key,
    required this.labId,
    required this.appointmentTime,
  }) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _itemSelectedValue;
  var _items = [
    "Urine test",
    "Blood test",
    "Urea breath test",
    "Lungs test",
    "Blood count test",
  ];
  var _gender = ['male', 'female', 'others'];
  var _enum = ['Yes', 'No'];

  String? _yesNo;
  String? name;
  String? fName;
  String? age;
  String? gender;
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
                          'Please fill the form',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CustomTextField(
                          hintText: 'Patient Name',
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Patient Name';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            name = val;
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CustomTextField(
                          hintText: 'Father Name',
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter patient father Name';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            fName = val;
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CustomTextField(
                          keyBoardType: TextInputType.number,
                          hintText: 'Age',
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter patient age';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            age = val;
                          },
                        ),
                        SizedBox(height: 12),
                        CustomTextField(
                          keyBoardType: TextInputType.phone,
                          hintText: 'Phone Number',
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter patient Phone Number';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            phoneNumber = val;
                          },
                        ),
                        Container(
                          height: 200,
                          child: Lottie.asset('assets/text.json'),
                        ),
                        Text(
                          'Please select your gender',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                    color: Color(0xffCFCCCC), width: 2)),
                            child: FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    // labelStyle: textStyle,
                                    errorStyle: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16.0),
                                    border: InputBorder.none,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: gender,
                                      isDense: true,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          gender = newValue;
                                          state.didChange(newValue);
                                        });
                                      },
                                      items: _gender.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Please select a medical test below',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                    color: Color(0xffCFCCCC), width: 2)),
                            child: FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    // labelStyle: textStyle,
                                    errorStyle: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16.0),
                                    border: InputBorder.none,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _itemSelectedValue,
                                      isDense: true,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _itemSelectedValue = newValue;
                                          state.didChange(newValue);
                                        });
                                      },
                                      items: _items.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Do you want Doctor Appointment after Test Report?',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                    color: Color(0xffCFCCCC), width: 2)),
                            child: FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    // labelStyle: textStyle,
                                    errorStyle: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 16.0),
                                    border: InputBorder.none,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _yesNo,
                                      isDense: true,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _yesNo = newValue;
                                          state.didChange(newValue);
                                        });
                                      },
                                      items: _enum.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        AuthButton(
                            title: 'Submit',
                            onTap: () {
                              if (_formKey.currentState!.validate() &&
                                  _yesNo != null &&
                                  gender != null &&
                                  _itemSelectedValue != null) {
                                try {
                                  setState(() {
                                    check = true;
                                  });
                                  DatabaseServices().addTestToDatabase(
                                      name!,
                                      fName!,
                                      age!,
                                      gender!,
                                      _itemSelectedValue!,
                                      this.widget.labId,
                                      AuthServices().getUid(),
                                      phoneNumber!,
                                      _yesNo!,
                                      widget.appointmentTime);
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return SubmittedScreen();
                                  }));
                                } catch (e) {
                                  setState(() {
                                    check = false;
                                  });
                                }
                              } else {
                                setState(() {
                                  check = false;
                                });
                                Fluttertoast.showToast(
                                    msg: "All fields are required to be filled",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
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
