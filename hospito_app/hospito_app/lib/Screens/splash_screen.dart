import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hospito_app/Screens/navigator_screen_for_patient.dart';
import 'package:hospito_app/Services/auth_services.dart';
import 'package:hospito_app/Services/database_services.dart';
import 'package:lottie/lottie.dart';
import '../Doctor/view/home_screen_for_doctor.dart';
import '../goto_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? check;
  Future checkForCast() async {
    if (AuthServices().getUser()) {
      check = await DatabaseServices().checkForCast();
    }
  }

  @override
  void initState() {
    super.initState();
    checkForCast();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return !AuthServices().getUser()
            ? GotoPage()
            : check!
                ? HomeScreenForDoctor()
                : NavigatorScreenForPatient();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset('assets/splash.json'),
      ),
    );
  }
}
