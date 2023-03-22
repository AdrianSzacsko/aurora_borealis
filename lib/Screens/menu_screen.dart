import 'package:aurora_borealis/Components/oval_component.dart';
import 'package:aurora_borealis/Screens/feed_screen.dart';
import 'package:aurora_borealis/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/custom_form_field.dart';
import '../Components/ext_string.dart';
import '../Components/snackbar.dart';
import 'register_screen.dart';
import 'login_screen.dart';
import 'weather_main_screen.dart';
import '../Components/app_bar.dart';
import 'profile_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  MenuScreenState createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> {
  bool isLoggedIn = false;
  late SharedPreferences cache;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: myAppBar(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/images/backgroundGreen.jpg',
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
            ),
          ),
          FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  cache = snapshot.data;
                  if (cache.getInt("user_id") != null) {
                    print("hasKey");
                    isLoggedIn = true;
                  }
                  return menuScreen();
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
        ],
      ),
    );
  }

  Widget menuScreen() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(40), topLeft: Radius.circular(40))),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  menuTileSignInUp(
                      context,
                      'Sign In',
                      () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()))
                          }),
                  menuTileSignInUp(
                      context,
                      "Sign Up",
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()))),
                  menuTile(
                      context,
                      "Weather",
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const WeatherMainScreen()))),
                  menuTile(
                      context,
                      "Feed",
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FeedScreen(),
                              settings: RouteSettings(
                                  arguments: cache.getInt("user_id"))))),
                  menuTile(
                      context,
                      "Profile",
                      () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ProfileScreen(),
                                    settings: RouteSettings(
                                        arguments: cache.getInt("user_id"))))
                          }),
                  menuTile(
                      context,
                      "Settings",
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ))),
                ],
              ),
            ),
          )),
    );
  }

  Widget menuTile(BuildContext context, String text, Function newScreen) {
    return CustomContainer(
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      onTap: () {
        newScreen();
      },
      width: double.infinity,
      height: 80,
    );
  }

  Widget menuTileSignInUp(
      BuildContext context, String text, Function newScreen) {
    return CustomContainer(
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: isLoggedIn == false
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
      ),
      onTap: () {
        isLoggedIn == false
            ? newScreen()
            : errorResponseBar("Already logged in", context);
      },
      width: double.infinity,
      height: 80,
    );
  }
}
