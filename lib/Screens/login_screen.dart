import 'package:aurora_borealis/Components/custom_map.dart';
import 'package:aurora_borealis/Screens/menu_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/custom_form_field.dart';
import '../Components/ext_string.dart';
import '../Network_Responses/auth.dart';
import '../Network_Responses/settings.dart';
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

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset('assets/images/backgroundGreen.jpg',
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,),
          ),
          loginScreen(),
          isLoading ? const Center(child: CircularProgressIndicator(),) : Container(),
        ],
      ),
    );
  }

  Widget loginScreen(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
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
                      'Login',
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
                                // print(emailController.text + " " + passwordController.text);
                                setState(() {
                                  isLoading = true;
                                });
                                await Auth.login(emailController.text, passwordController.text, context);
                                SharedPreferences cache = await SharedPreferences.getInstance();
                                if (cache.containsKey('fcm_token')){
                                  await Settings.setFCM(cache.getString('fcm_token')!);
                                }
                                setState(() {
                                  isLoading = false;
                                });
                                //change screen
                              }
                            },
                            child: const Text('Login'),
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
                                'Register',
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
    );
  }
}


