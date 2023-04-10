import 'package:flutter/material.dart';

import '../../../_variables/global_variables.dart';
import '../../theme/theme.dart';
import '../../../logic/firebase_auth/firebase_auth_logic.dart';
import '../../../logic/form_validation/form_validator.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State createState() {
    return _SignInScreen();
  }
}

class _SignInScreen extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgoundImage,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder(
            future: initializeFirebase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: h * 0.1),
                          child: Text(
                            'Sign In',
                            style: TextStyle(color: primaryColor, fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.next,
                            controller: emailController,
                            validator: (value) => Validator.validateEmail(email: value!),
                            onSaved: (String? val) {
                              setState(() {
                                email = val;
                              });
                            },
                            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                                hintText: "Email Address",
                                hintStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              obscureText: true,
                              controller: passwordController,
                              validator: (value) => Validator.validatePassword(password: value!),
                              onSaved: (String? val) {
                                setState(() {
                                  password = val;
                                });
                              },
                              onFieldSubmitted: null,
                              textInputAction: TextInputAction.done,
                              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                              cursorColor: primaryColor,
                              decoration: InputDecoration(
                                  hintText: "Password", hintStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500))),
                        ),

                        /// forgot password text, navigates user to ResetPasswordScreen
                        /// and this is only visible when logging with email and password
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                          ),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {},
                              child: const Text(
                                'Forgot password?',
                                style:
                                    TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 30),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side: BorderSide(
                                      color: primaryColor,
                                    ),
                                  ),
                                  backgroundColor: primaryColor),
                              child: const Text(
                                'Log In',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  await signInUsingEmailPassword(
                                    context,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
