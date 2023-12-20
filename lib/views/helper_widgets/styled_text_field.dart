// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StyledTextField extends StatelessWidget {
  List<TextInputFormatter>? inputFormaters;
  String? error;
  String? labelText;
  String hint;
  FocusNode? focusNode;
  TextInputType inputType;
  TextEditingController controller;
  Widget? icon;
  StyledTextField({
    this.focusNode,
    this.labelText,
    this.inputFormaters,
    this.error,
    required this.hint,
    this.inputType = TextInputType.text,
    required this.controller,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 40,
              blurStyle: BlurStyle.normal,
              spreadRadius: 10),
        ],
      ),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        inputFormatters: inputFormaters,
        keyboardType: inputType,
        obscureText: inputType == TextInputType.visiblePassword,
        maxLines: 1,
        decoration: InputDecoration(
            label: labelText != null
                ? Text(
                    labelText!,
                    style: const TextStyle(color: Color(0xff202c34)),
                  )
                : null,
            error: error != null
                ? Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  )
                : null,
            prefixIcon: icon,
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 14,
            )),
      ),
    );
  }
}
