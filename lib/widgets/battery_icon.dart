import 'package:flutter/material.dart';

Widget batteryIcon(int percentage) {
  percentage = percentage < 5 ? 5 : percentage;
  return SizedBox(
    height: 29,
    width: 70,
    child: Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          width: 70,
          height: 15,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
        Container(
          width: 65,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              width: 1.5,
              color: Colors.black,
            ),
          ),
          child: percentage != 404
              ? Row(
                mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: (percentage / 100) * 58,
                      margin: EdgeInsets.all(percentage > 19 ? 2 : 3),
                      decoration: BoxDecoration(
                        color: percentage > 60
                            ? Colors.green
                            : percentage < 40
                                ? Colors.red
                                : Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text("X"),
                ),
        ),
      ],
    ),
  );
}
