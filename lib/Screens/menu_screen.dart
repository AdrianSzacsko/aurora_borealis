import 'package:aurora_borealis/constants.dart';
import 'package:flutter/material.dart';
import '../Components/custom_form_field.dart';
import '../Components/ext_string.dart';
import 'register_screen.dart';
import 'login_screen.dart';
import 'weather_main_screen.dart';
import '../Components/app_bar.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  MenuScreenState createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: myAppBar(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: Placeholder(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        menuTile(context, 'Sign In', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()))),
                        menuTile(context, "Sign Up", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()))),
                        menuTile(context, "Weather", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WeatherMainScreen()))),
                        menuTile(context, "Feed", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()))),
                        menuTile(context, "Profile", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()))),
                        menuTile(context, "Settings", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()))),
                      ],
                    ),
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget menuTile(BuildContext context, String text, Function newScreen){
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: InkWell(
        splashColor: primaryColor,
        onTap: () {
          newScreen();
        },
        child: SizedBox(
          width: double.infinity,
          height: 80,
          child: Center(child: Text(text)),
        ),
      )
    );
  }

}