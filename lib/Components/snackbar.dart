import 'package:aurora_borealis/constants.dart';
import 'package:flutter/material.dart';

void errorResponseBar(String text, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      content: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white,),
            const SizedBox(width: 5,),
            Text(
              text,
              //textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16
              ),
            ),
          ],
        )
      )
    ),
  );
}

void successResponseBar(String text, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        backgroundColor: primaryColor.shade900,
        content: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, color: Colors.white,),
                const SizedBox(width: 5,),
                Text(
                  text,
                  //textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),
                ),
              ],
            )
        )
    ),
  );
}