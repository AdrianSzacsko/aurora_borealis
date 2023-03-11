import 'package:aurora_borealis/Components/custom_map.dart';
import 'package:aurora_borealis/Screens/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/custom_form_field.dart';
import '../Components/ext_string.dart';
import 'register_screen.dart';
import '../Components/app_bar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:aurora_borealis/Network/auth.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:geolocator/geolocator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: CustomMap(
              mapController: _mapController,
              //coors: latLng.LatLng(48.269798, 19.820565),
              onLongPress: null,
            ),
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
                    padding: const EdgeInsets.only(top: 50, right: 16, left: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Sign In',
                          style: TextStyle(
                              fontSize: 28
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CustomFormField(
                                  controller: emailController,
                                  hintText: 'Enter Email',
                                  labelText: 'Email',
                                  validator: (value) {
                                    if (value!.isValidEmail && value.isNotEmpty) {
                                      return null;
                                    } else {
                                      return 'Enter valid Email';
                                    }
                                  },
                                  prefixIcon: Icons.email_outlined,
                                  isPassword: false),
                              CustomFormField(
                                  controller: passwordController,
                                  hintText: 'Enter Password',
                                  labelText: 'Password',
                                  validator: (value) {
                                    if (value!.isValidPassword && value.isNotEmpty) {
                                      return null;
                                    } else {
                                      return 'Enter valid Password';
                                    }
                                  },
                                  prefixIcon: Icons.password_outlined,
                                  isPassword: true),
                              FilledButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    print(emailController.text + " " + passwordController.text);
                                    var response = await Auth().login(emailController.text, passwordController.text);
                                    if (response.statusCode == 200){
                                      SharedPreferences shared = await SharedPreferences.getInstance();
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuScreen(),
                                      settings: RouteSettings(arguments: shared.getInt('user_id'))));
                                    }
                                    else {
                                      //TODO error message
                                    }
                                    //change screen
                                  }
                                },
                                child: const Text('Sign In'),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16,
                              bottom: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Don\'t have an Account?',
                                style: TextStyle(
                                    fontSize: 14
                                ),
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      textStyle: const TextStyle(
                                          fontSize: 14
                                      )),
                                  onPressed:  () {Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));},
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        fontSize: 14
                                    ),
                                  )
                              )
                            ],
                          ),
                        )
                      ],
                    )
                ),
              )
            ),
          )
        ],
      ),
    );
  }
}
