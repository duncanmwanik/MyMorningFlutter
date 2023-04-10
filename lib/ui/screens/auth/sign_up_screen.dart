import 'package:flutter/material.dart';

import '../../../_variables/global_variables.dart';
import '../../theme/theme.dart';
import '../../widgets/toast.dart';
import '../../../logic/firebase_auth/firebase_auth_logic.dart';
import '../../../logic/form_validation/form_validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  String? firstName, lastName, email, password, confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/back.jpg"),
          fit: BoxFit.cover,
        ),
      ),
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
                            padding: EdgeInsets.only(top: h * 0.1, bottom: 10),
                            child: Text(
                              'Register',
                              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 25.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.words,
                              validator: (value) => Validator.validateName(name: value!),
                              onSaved: (String? val) {
                                firstName = val;
                              },
                              controller: firstNameController,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(height: 0.8, fontSize: 18.0, fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                  hintText: 'First Name',
                                  hintStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.words,
                              validator: (value) => Validator.validateName(name: value!),
                              controller: lastNameController,
                              onSaved: (String? val) {
                                lastName = val;
                              },
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(height: 0.8, fontSize: 18.0, fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                  hintText: 'Last Name', hintStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (value) => Validator.validateEmail(email: value!),
                              controller: emailController,
                              onSaved: (String? val) {
                                email = val;
                              },
                              style: const TextStyle(height: 0.8, fontSize: 18.0, fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                  hintText: 'Email', hintStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              controller: passwordController,
                              validator: (value) => Validator.validatePassword(password: value!),
                              onSaved: (String? val) {
                                password = val;
                              },
                              style: const TextStyle(height: 0.8, fontSize: 18.0, fontWeight: FontWeight.w500),
                              cursorColor: primaryColor,
                              decoration: InputDecoration(
                                  hintText: 'Password', hintStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              obscureText: true,
                              controller: confirmPasswordController,
                              validator: (value) => Validator.validatePassword(password: value!),
                              onSaved: (String? val) {
                                confirmPassword = val;
                              },
                              style: const TextStyle(height: 0.8, fontSize: 18.0, fontWeight: FontWeight.w500),
                              cursorColor: primaryColor,
                              decoration: InputDecoration(
                                  hintText: 'Confirm Password',
                                  hintStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                padding: const EdgeInsets.only(top: 12, bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: BorderSide(
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  if (passwordController.text == confirmPasswordController.text) {
                                    await registerUsingEmailPassword(
                                      context,
                                      name: "${firstNameController.text}|${lastNameController.text}",
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                  toast(0, "Passwords need to match!");
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          // ListTile(
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
    );
  }
}
