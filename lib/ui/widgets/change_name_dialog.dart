import 'package:flutter/material.dart';

import '../../_variables/global_variables.dart';
import '../theme/theme.dart';

Future changeNameDialog(
    {required BuildContext context,
    required String description,
    required TextEditingController textController,
    required int maxLength,
    required GestureTapCallback onTap}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Text(
            description,
            style: TextStyle(color: Colors.black54),
          ),
          content: Container(
            width: w * 0.8,
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                width: 0.5,
                color: primaryColor,
              ),
            ),
            child: TextField(
              controller: textController,
              maxLines: 3,
              maxLength: maxLength,
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              onPressed: (() => Navigator.pop(context, false)),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              onPressed: onTap,
              child: Text("Change"),
            ),
          ],
        );
      });
}
