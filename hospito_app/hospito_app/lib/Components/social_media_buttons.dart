import 'package:flutter/material.dart';

class SocialMediaButton extends StatelessWidget {
  final String icon;
  final Color? color;
  const SocialMediaButton({Key? key, required this.icon, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color ?? Colors.grey,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          icon,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ));
  }
}
