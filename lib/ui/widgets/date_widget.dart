import 'package:flutter/material.dart';

import '../../_variables/date_time_variables.dart';
import '../../_variables/global_variables.dart';

Widget dateIcon({required int dayNumber, required int alarmNumber}) {
  return GestureDetector(
    onTap: () {
      globalWatch.selectNewDate(dayNumber);
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/arrow.png',
          color: globalWatch.selectedDate == dayNumber ? Colors.black : Colors.transparent,
          height: w * 0.05,
          width: w * 0.05,
        ),
        Text(
          weekDaysList[dayNumber].dayShortName,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: h * 0.005,
        ),
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: globalWatch.selectedDate == dayNumber
                ? Colors.purple.shade200
                : (alarmNumber > 0)
                    ? Colors.lightBlue.shade100
                    : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
              ),
            ],
          ),
          child: SizedBox(
            width: w * 0.07,
            height: w * 0.07,
            child: Center(
              child: Stack(
                children: <Widget>[
                  Center(
                      child: Image.asset(
                    "assets/images/alarm.png",
                  )),
                  Center(
                      child: Text(
                    '$alarmNumber',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  )),
                ], //<Widget>[]
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
