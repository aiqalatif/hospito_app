import 'package:flutter/cupertino.dart';
import 'package:hospito_app/Screens/Authentication/sign_in.dart';
import 'package:hospito_app/Screens/Authentication/sign_up.dart';

class ToggleScreen extends StatefulWidget {
  final String cast;
  const ToggleScreen({Key? key, required this.cast}) : super(key: key);

  @override
  _ToggleScreenState createState() => _ToggleScreenState();
}

class _ToggleScreenState extends State<ToggleScreen> {
  bool check = true;
  toggleScreen() {
    setState(() {
      check = !check;
    });
  }

  @override
  Widget build(BuildContext context) {
    return check
        ? SignIn(
            function: () {
              toggleScreen();
            },
            cast: widget.cast,
          )
        : SignUp(
            function: () {
              toggleScreen();
            },
            cast: widget.cast,
          );
  }
}
