import 'package:flutter/material.dart';
import '../Components/custom_form_field.dart';
import '../Components/ext_string.dart';
import '../Network/auth.dart';
import 'login_screen.dart';
import '../Components/app_bar.dart';
import 'menu_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
            child: Image.asset('assets/images/backgroundGreen.jpg',
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,),
          ),
          Align(
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
                          'Sign Up',
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
                                  controller: firstNameController,
                                  hintText: 'Enter First Name',
                                  labelText: 'First Name',
                                  validator: (value) {
                                    if (value!.isValidName && value.isNotEmpty) {
                                      return null;
                                    } else {
                                      return 'Enter valid First Name';
                                    }
                                  },
                                  prefixIcon: Icons.person,
                                  isPassword: false),
                              CustomFormField(
                                  controller: lastNameController,
                                  hintText: 'Enter Last Name',
                                  labelText: 'Last Name',
                                  validator: (value) {
                                    if (value!.isValidName && value.isNotEmpty) {
                                      return null;
                                    } else {
                                      return 'Enter valid Last Name';
                                    }
                                  },
                                  prefixIcon: Icons.person,
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
                                    var response = await Auth().register(emailController.text, firstNameController.text, lastNameController.text, passwordController.text);
                                    if (response.statusCode == 201){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                                    }
                                    else {
                                      //TODO error message
                                    }
                                    //change screen
                                  }
                                  else {

                                  }
                                },
                                child: const Text('Sign Up'),
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
                                'Already have an Account?',
                                style: TextStyle(
                                    fontSize: 14
                                ),
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      textStyle: const TextStyle(
                                          fontSize: 14
                                      )),
                                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));},
                                  child: const Text(
                                    'Sign In',
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
