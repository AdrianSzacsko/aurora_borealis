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