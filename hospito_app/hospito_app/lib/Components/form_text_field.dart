import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final String title;
  final dynamic keyboardType;
  final dynamic onChanged;
  const FormTextField({
    Key? key,
    required this.title,
    required this.onChanged,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xffCFCCCC), width: 2),
          borderRadius: BorderRadius.circular(7),
        ),
        child: TextField(
          keyboardType: keyboardType ?? TextInputType.text,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: title,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
