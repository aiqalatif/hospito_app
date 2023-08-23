import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospito_app/Screens/Authentication/forgot_password.dart';
import 'package:lottie/lottie.dart';

import '../../Components/auth_button.dart';
import '../../Components/custom_text_field.dart';
import '../../Components/social_media_buttons.dart';
import '../../Doctor/view/home_screen_for_doctor.dart';
import '../../Services/auth_services.dart';
import '../../Services/database_services.dart';
import '../navigator_screen_for_patient.dart';

class SignIn extends StatefulWidget {
  final dynamic function;
  final String cast;
  const SignIn({Key? key, required this.function, required this.cast})
      : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool check = true;
  bool scroll = false;
  String? email;
  String? password;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return scroll
        ? Scaffold(
            body: Center(
              child: Container(
                height: 100,
                child: Lottie.asset('assets/heart.json'),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white.withOpacity(0.9),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign in',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              validation: (value) => value!.isEmpty
                                  ? 'Please enter your email'
                                  : null,
                              keyboardtype: TextInputType.emailAddress,
                              hint: 'Enter Email',
                              prefixIcon: Icons.email,
                              onChanged: (val) {
                                email = val;
                              },
                            ),
                            CustomTextField(
                              validation: (value) => value!.length < 6
                                  ? 'Password must be 6+ characters'
                                  : null,
                              hint: 'Enter Password',
                              prefixIcon: Icons.lock_sharp,
                              suffixIcon: check
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              check: check,
                              function: () {
                                setState(() {
                                  check = !check;
                                });
                              },
                              onChanged: (val) {
                                password = val;
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Forgot Password ?',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ForgotPassword();
                                }));
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AuthButton(
                              title: 'Sign In',
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    scroll = true;
                                  });
                                  final result = await AuthServices()
                                      .signInUserWithEmailAndPassword(
                                          email!, password!);
                                  if (result != null) {
                                    if (widget.cast == 'Doctor') {
                                      bool checkForCast =
                                          await DatabaseServices()
                                              .checkForCast();
                                      if (checkForCast) {
                                        Navigator.pushAndRemoveUntil(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return HomeScreenForDoctor();
                                        }), (route) => false);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                "This account registered with patient",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        Fluttertoast.showToast(
                                            msg:
                                                "We have redirected your to patient console",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        Navigator.pushAndRemoveUntil(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return NavigatorScreenForPatient();
                                        }), (route) => false);
                                      }
                                    } else {
                                      bool checkForCast =
                                          await DatabaseServices()
                                              .checkForCast();
                                      if (checkForCast) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "This account registered with doctor",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        Fluttertoast.showToast(
                                            msg:
                                                "We have redirected your to doctor console",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 2,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        Navigator.pushAndRemoveUntil(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return HomeScreenForDoctor();
                                        }), (route) => false);

                                        // Navigator.pushReplacement(context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) {
                                        //   return HomeScreenForDoctor();
                                        // }));
                                      } else {
                                        Navigator.pushAndRemoveUntil(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return NavigatorScreenForPatient();
                                        }), (route) => false);
                                      }
                                    }
                                  } else {
                                    setState(() {
                                      scroll = false;
                                    });
                                    Fluttertoast.showToast(
                                        msg:
                                            "Wrong credentials or user don't exist",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 3,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                  setState(() {
                                    scroll = false;
                                  });
                                }
                              }),
                          Center(
                            child: Container(
                              child: Lottie.asset('assets/text.json'),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * 0.11,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have account? ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                InkWell(
                  onTap: this.widget.function,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.deepOrangeAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
