import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospito_app/Nearby/nearby_screen.dart';
import 'package:hospito_app/Screens/result_screen.dart';
import 'package:hospito_app/Screens/splash_screen.dart';
import 'package:lottie/lottie.dart';
import '../Models/user_model.dart';
import '../Nearby/location_model.dart';
import '../Nearby/location_services.dart';
import '../Services/auth_services.dart';
import '../Services/database_services.dart';
import 'appointment_screen.dart';

class NavigatorScreenForPatient extends StatefulWidget {
  const NavigatorScreenForPatient({Key? key}) : super(key: key);

  @override
  _NavigatorScreenForPatientState createState() =>
      _NavigatorScreenForPatientState();
}

class _NavigatorScreenForPatientState extends State<NavigatorScreenForPatient> {
  int currentIndex = 0;

  getScreen() {
    if (currentIndex == 0) {
      return NearByScreen();
    } else if (currentIndex == 1) {
      return AppointmentScreen();
    } else {
      return ResultScreen();
    }
  }

  UserModel? model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        width: 250,
        child: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<DocumentSnapshot>(
                      stream:
                          DatabaseServices().getUser(AuthServices().getUid()),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Container(
                              height: 100,
                              child: Lottie.asset('assets/heart.json'),
                            ),
                          );
                        }
                        var item = snapshot.data!;
                        model = UserModel(
                            name: item.get('User Name'),
                            email: item.get('Email'),
                            photoUrl: item.get('Profile Url'));

                        return Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('assets/profile.png'),
                            ),
                            SizedBox(height: 20),
                            Text(
                              model!.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              model!.email,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        );
                      }),
                ],
              ))
            ],
          ),
        ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_contact_calendar_sharp),
            label: 'Results',
          ),
        ],
      ),
      appBar: AppBar(
        elevation: 0.0,
        title: Center(
          child: Text(
            currentIndex == 0
                ? 'Nearby Labs'
                : currentIndex == 1
                    ? 'Appointments'
                    : 'Results',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => TextButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            child: Icon(
              Icons.menu,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          IconButton(
              color: Colors.black,
              onPressed: () async {
                await AuthServices().logout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return SplashScreen();
                }));
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      body: getScreen(),
    );
  }
}
