import 'package:flutter/material.dart';

import '../../../helpers/datetime_helper.dart';

Widget currentWeekDay() {
  return Padding(
    padding: const EdgeInsets.only(top: 1),
    child: Text(
      getWeekDay(),
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
    ),
  );
}
