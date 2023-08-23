import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'Screens/Authentication/toggle_screen.dart';

class GotoPage extends StatelessWidget {
  const GotoPage({Key? key}) : super(key: key);

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
                  'Welcome To The \nHospito',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                ),
                SizedBox(height: 50),
                Text(
                  'Register as a',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ToggleScreen(
                        cast: 'Patient',
                      );
                    }));
                  },
                  child: Container(
                    width: 130,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Patient',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ToggleScreen(
                        cast: 'Doctor',
                      );
                    }));
                  },
                  child: Container(
                    width: 130,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Lab',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
