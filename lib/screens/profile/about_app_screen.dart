import 'package:flutter/material.dart';

import '../../variables/global_variables.dart';
import '../../config/theme/theme.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  @override
  initState() {
    super.initState();

    globalWatch.updateUserDetails();
  }

  Widget divider() {
    return Divider(
      height: 0,
    );
  }

  Widget titleText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: primaryColor.withOpacity(0.7), fontWeight: FontWeight.w600),
    );
  }

  Widget leadingText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
    );
  }

  Widget trailingText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w500),
    );
  }

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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () async {
                await globalWatch.updateSelectedTab(0);
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: Colors.black,
              )),
        ),
        body: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Image.asset(
              'assets/images/logo-trp.png',
              height: w * 0.6,
              width: w * 0.6,
            ), //
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.35),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  "MyMorning",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.1),
              child: Text(
                "MyMorning app allows you to set and manage non-disruptive and peaceful alarms on your MyMorning band.\n",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
