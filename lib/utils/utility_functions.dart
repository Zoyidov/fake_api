import 'package:flutter/material.dart';

InputDecoration getTextFieldDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1.5,
        )),
    fillColor: Colors.grey.shade300,
    filled: true,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(
        color: Colors.green,
        width: 1.5,
      ),
    ),
  );
}


showCustomMessage(BuildContext context, String message){
  ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         backgroundColor: Colors.indigo,
          content: Text(message)));
}
