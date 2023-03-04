

import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget{

  const CustomContainer({
    required this.child,
    Key? key, required,
  }) : super(key: key);
  final Widget? child;


  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
        color: Colors.black,
    ),
    borderRadius: const BorderRadius.all(
    Radius.circular(20))),
    child: child,
    );
  }

}