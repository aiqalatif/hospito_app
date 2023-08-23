import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final dynamic onChanged;
  final String? hintText;
  final dynamic validation;
  final dynamic prefixIcon;
  final dynamic maxLines;
  final dynamic minLines;
  final String? initialValue;
  final dynamic keyBoardType;
  final dynamic controller;
  CustomTextField(
      {Key? key,
      this.controller,
      this.keyBoardType,
      this.hintText,
      this.prefixIcon,
      this.initialValue,
      this.onChanged,
      this.maxLines,
      this.minLines,
      this.validation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validation,
      onChanged: onChanged,
      controller: controller,
      // textAlign: TextAlign.center,
      maxLines: maxLines ?? 1,
      initialValue: initialValue ?? '',
      keyboardType: keyBoardType ?? TextInputType.text,
      decoration: InputDecoration(
        label: RichText(
          text: TextSpan(
              text: hintText,
              style: TextStyle(color: Colors.grey),
              children: [
                TextSpan(
                    text: '  *',
                    style: TextStyle(
                      color: Colors.red,
                    ))
              ]),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(7.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(7.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
          borderRadius: BorderRadius.circular(7.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(7.0),
        ),
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        prefixIcon: prefixIcon,
        border: InputBorder.none,
      ),
    );
  }
}
