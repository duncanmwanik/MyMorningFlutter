import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../variables/global_variables.dart';
import '../../state/global_state.dart';
import '../../config/theme/theme.dart';
import '../../../widgets/back_button.dart';
import '../../../widgets/bottom_navbar.dart';
import '../home/home_screen.dart';
import 'about_app_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

  Future<bool> onWillPop() async {
    await globalWatch.updateSelectedTab(0);
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => HomeScreen(),
      ),
      (route) => false,
    );

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: primaryColor,
            elevation: 0,
            leading: customBackButton(context, Colors.white),
            centerTitle: true,
            title: Text(
              'Profile & Settings',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          bottomNavigationBar: bottomNavbar(context, false),
          body: Consumer<GlobalModel>(builder: (context, g, child) {
            return ListView(
              shrinkWrap: true,
              children: [
                Container(
                  height: h * 0.25,
                  decoration: BoxDecoration(color: primaryColor),
                  child: Container(
                    margin: EdgeInsets.all(h * 0.04),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color: Colors.white,
                      ),
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage('assets/images/icon_profile.png'),
                      ),
                    ),
                  ),
                ),
                // ********************************* PROFILE
                ListTile(tileColor: Colors.black12, leading: titleText("PROFILE")),
                divider(),
                ListTile(
                  tileColor: Colors.white,
                  leading: leadingText('Name'),
                  trailing: trailingText(g.userName.replaceAll("|", " ")),
                  onTap: () {},
                ),
                divider(),
                ListTile(
                  tileColor: Colors.white,
                  leading: leadingText('Email'),
                  trailing: trailingText(g.userEmail),
                  onTap: () {},
                ),
                divider(),
                // ********************************* GENERAL
                ListTile(tileColor: Colors.black12, leading: titleText("GENERAL")),
                divider(),
                Consumer<GlobalModel>(builder: (context, appTheme, child) {
                  return ListTile(
                    tileColor: Colors.white,
                    leading: leadingText('Dark Theme'),
                    trailing: CupertinoSwitch(
                      value: g.enablePushNotifications,
                      activeColor: primaryColor,
                      onChanged: (value) {
                        appTheme.updatePushNotifications(value);
                      },
                    ),
                    onTap: () {
                      g.updatePushNotifications(!g.enablePushNotifications);
                    },
                  );
                }),
                divider(),
                // ********************************* SUPPORT
                ListTile(tileColor: Colors.black12, leading: titleText("SUPPORT")),
                divider(),
                ListTile(
                  tileColor: Colors.white,
                  leading: leadingText('About Application'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutAppScreen()),
                    );
                  },
                ),
                divider(),
                ListTile(
                  tileColor: Colors.white,
                  leading: leadingText('Send Feedback'),
                  onTap: () async {
                    String email = Uri.encodeComponent("hey@mymorning.com");
                    String subject = Uri.encodeComponent("Feedback");
                    String body = Uri.encodeComponent("Hello...");
                    Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
                    if (await launchUrl(mail)) {
                      //email app opened
                    } else {
                      //email app is not opened
                    }
                  },
                ),
                divider(),
                ListTile(
                  tileColor: Colors.white,
                  leading: leadingText('App Version'),
                  trailing: trailingText('1.0'),
                  onTap: () {},
                ),
                divider(),
                divider(),
              ],
            );
          }),
        ));
  }
}
