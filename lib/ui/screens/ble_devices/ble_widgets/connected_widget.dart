
// import 'package:flutter/material.dart';

// Widget connectedWidget(){
//   return Container(
//                       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                       padding: EdgeInsets.only(bottom: 5),
//                       decoration: BoxDecoration(color: Colors.white60, borderRadius: BorderRadius.all(Radius.circular(40))),
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: w * 0.1, vertical: 0),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Flexible(
//                                   child: Text(
//                                     ble.device!.name,
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.w700),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 IconButton(
//                                     onPressed: () async {
//                                       TextEditingController? textController = TextEditingController(text: ble.device!.name);

//                                       bool success = await changeNameDialog(
//                                           context: context,
//                                           description: "Edit device name",
//                                           textController: textController,
//                                           maxLength: 19,
//                                           onTap: () {
//                                             if (textController.text.isNotEmpty && textController.text.length < 20) {
//                                               sendDataToDevice("n${textController.text}");
//                                               Navigator.pop(context, true);
//                                             } else if (textController.text.length >= 20) {
//                                               toast(0, "Name is too long!");
//                                             } else {
//                                               toast(0, "Name is too short!");
//                                             }
//                                           });

//                                       if (success) {
//                                         toast(1, "Please restart your device to see changes.");
//                                       }
//                                     },
//                                     icon: Icon(
//                                       Icons.edit,
//                                       color: primaryColor,
//                                     ))
//                               ],
//                             ),
//                           ),
//                           Wrap(
//                             alignment: WrapAlignment.spaceEvenly,
//                             crossAxisAlignment: WrapCrossAlignment.center,
//                             children: [
//                               Text(
//                                 ble.batteryPercentage == 404 ? "X" : "${ble.batteryPercentage}%",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
//                               ),
//                               SizedBox(
//                                 width: 5,
//                               ),
//                               batteryIcon(ble.batteryPercentage),
//                               SizedBox(
//                                 width: w * 0.15,
//                               ),
//                               AdvancedSwitch(
//                                 activeChild: Text('ON'),
//                                 inactiveChild: Text('OFF'),
//                                 borderRadius: BorderRadius.circular(5),
//                                 width: 76,
//                                 controller: controller,
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               disconnectFromDevice(ble.device);
//                             },
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.black12,
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20),
//                                 )),
//                             child: Text(
//                               "disconnect",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
// }