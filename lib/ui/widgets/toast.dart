// --------------------------------- Notification toast ---------------------------------
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toast(int s, String m) {
  Fluttertoast.showToast(
      msg: m,
      gravity: ToastGravity.TOP,
      backgroundColor: s == 0
          ? Colors.red
          : s == 1
              ? Colors.green
              : Colors.white,
      textColor: Colors.black);
}
