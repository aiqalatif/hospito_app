import 'package:flutter/material.dart';
import 'package:hospito_app/Screens/splash_screen.dart';
import 'package:lottie/lottie.dart';

import '../../Screens/Authentication/toggle_screen.dart';

class DoctorWelcomeScreen extends StatelessWidget {
  const DoctorWelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isNotPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 30, vertical: isNotPortrait ? 100 : 50),
            child: Column(
              crossAxisAlignment: isNotPortrait
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                ),
                Text(
                  'Dear Doctor Welcome to the\nHospito',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome to our application,Respected Doctor Please share your Details with us',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.grey),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SplashScreen();
                    }));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 30),
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
