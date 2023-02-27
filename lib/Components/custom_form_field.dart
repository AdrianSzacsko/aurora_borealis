import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ext_string.dart';

class CustomFormField extends StatelessWidget {
  CustomFormField({
    Key? key,
    required this.hintText,
    required this.labelText,
    required this.prefixIcon,
    required this.isPassword,
    this.controller,
    this.inputFormatters,
    this.validator,
  }) : super(key: key);
  final String hintText;
  final String labelText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;



  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: validator,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            //errorText: !wrong ? null : 'Bad email',
            border: const OutlineInputBorder(),
            prefixIcon: Icon(
                prefixIcon
            ),
            /*suffixIcon: !wrong ? null : const Icon(
              Icons.error,
            ),*/
          ),
        ),
      );
  }

}