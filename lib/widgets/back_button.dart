// custom back button
import 'package:flutter/material.dart';

import '../variables/global_variables.dart';
import '../screens/home/home_screen.dart';

Widget customBackButton(BuildContext context, Color color) {
  return IconButton(
      onPressed: () async {
        await globalWatch.updateSelectedTab(0);
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => HomeScreen(),
          ),
          (route) => false,
        );
      },
      icon: Icon(
        Icons.arrow_back_ios,
        color: color,
      ));
}
