import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../variables/global_variables.dart';
import '../../../state/global_state.dart';
import '../../../../widgets/date_bubble.dart';

Widget weekdayBubblesRow(BuildContext context) {
  return Stack(
    alignment: Alignment.topLeft,
    children: [
      // ------------------------------ Black Line
      Container(
        margin: EdgeInsets.only(top: 2.5, left: w * 0.05, right: w * 0.05),
        height: 2,
        color: Colors.black,
      ),
      // ------------------------------ Day Bubbles
      Consumer<GlobalModel>(builder: (context, global, child) {
        Map<int, List<String>> mapD = global.alarmMap;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            weekdayBubble(dayNumber: 0, alarmNumber: mapD[0]!.length),
            weekdayBubble(dayNumber: 1, alarmNumber: mapD[1]!.length),
            weekdayBubble(dayNumber: 2, alarmNumber: mapD[2]!.length),
            weekdayBubble(dayNumber: 3, alarmNumber: mapD[3]!.length),
            weekdayBubble(dayNumber: 4, alarmNumber: mapD[4]!.length),
            weekdayBubble(dayNumber: 5, alarmNumber: mapD[5]!.length),
            weekdayBubble(dayNumber: 6, alarmNumber: mapD[6]!.length),
          ],
        );
      }),
    ],
  );
}
