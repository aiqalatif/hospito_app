import 'package:flutter/material.dart';
import 'package:hospito_app/Doctor/view/lab_form.dart';
import '../../Screens/splash_screen.dart';
import '../../Services/auth_services.dart';
import 'manage_appointment-screen.dart';
import 'manage_labs_sreen.dart';

class HomeScreenForDoctor extends StatefulWidget {
  const HomeScreenForDoctor({Key? key}) : super(key: key);

  @override
  _HomeScreenForDoctorState createState() => _HomeScreenForDoctorState();
}

class _HomeScreenForDoctorState extends State<HomeScreenForDoctor> {
  int currentIndex = 0;

  getScreen() {
    if (currentIndex == 0) {
      return ManageLabsScreen();
    } else if (currentIndex == 1) {
      return ManageAppointmentScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LabForm();
          }));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int) {
          setState(() {
            currentIndex = int;
          });
        },
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Appointments',
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.0,
        title: Center(
          child: Text(
            'Home',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await AuthServices().logout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return SplashScreen();
                }));
              },
              icon: Icon(
                Icons.logout,
              )),
        ],
      ),
      body: getScreen(),
    );
  }
}
