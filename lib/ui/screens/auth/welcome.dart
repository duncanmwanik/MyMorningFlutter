import 'package:flutter/material.dart';

import '../../../methods/globals.dart';
import '../../theme/theme.dart';
import 'sign_in.dart';
import 'sign_up.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  initState() {
    // setFirstTimeState();
    super.initState();
  }

  Widget circleIndicator(Color? paint) {
    return Container(
      width: w * 0.03,
      height: w * 0.03,
      margin: EdgeInsets.symmetric(horizontal: w * 0.05),
      decoration: BoxDecoration(
        color: paint,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // get device screen size and save them globally
    getDeviceSize(context);

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/back.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Text(
              "Welcome to \n MyMorning.",
              style: TextStyle(fontSize: 35, color: primaryColor, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
            ),
          ),
          Image.asset(
            'assets/images/logo-trp.png',
            height: w * 0.6,
            width: w * 0.6,
          ), //

          Flexible(
            child: Text(
              "Your peaceful morning \n experience starts now!",
              style: TextStyle(fontSize: 25, color: primaryColor.withOpacity(0.8), fontWeight: FontWeight.w500),
            ),
          ),

          // Sign In button
          Flexible(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  fixedSize: Size(w * 0.6, h * 0.07),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  )),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
              child: Text(
                'Sign In',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          SizedBox(
            height: 15,
          ),

          // Sign Up button
          Flexible(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  fixedSize: Size(w * 0.6, h * 0.07),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  )),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                circleIndicator(primaryColor),
                circleIndicator(Colors.white70),
                circleIndicator(Colors.white70),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
