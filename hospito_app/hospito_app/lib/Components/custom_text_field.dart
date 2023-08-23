import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final dynamic keyboardtype;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final dynamic function;
  final bool check;
  final dynamic onChanged;
  final dynamic validation;
  const CustomTextField({
    Key? key,
    this.validation,
    required this.onChanged,
    this.check = false,
    this.function,
    required this.hint,
    required this.prefixIcon,
    this.suffixIcon,
    this.keyboardtype,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: TextFormField(
        keyboardType: keyboardtype ?? TextInputType.text,
        validator: validation,
        onChanged: onChanged,
        obscureText: check ? true : false,
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: Icon(
            prefixIcon,
            size: 20,
            color: Colors.grey,
          ),
          suffixIcon: IconButton(
              color: check ? Colors.grey : Colors.blue,
              onPressed: function,
              icon: Icon(
                suffixIcon,
              )),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
