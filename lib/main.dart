import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/login_screen.dart';
import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
            colorSchemeSeed: primaryColor,
            fontFamily: "Roboto",
            textTheme: GoogleFonts.robotoTextTheme(
              Theme.of(context).textTheme,)
        ),
        home: const LoginScreen(),
      );
  }
}