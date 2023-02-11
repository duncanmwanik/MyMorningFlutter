import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/globals.dart';

Widget loadingWidget(BuildContext context) {
  double wS = MediaQuery.of(context).size.width;
  double hS = MediaQuery.of(context).size.height;
  return Consumer<GlobalModel>(builder: (context, global, child) {
    return Visibility(
      visible: global.showLoading,
      child: Container(
        height: hS,
        width: wS,
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: SizedBox(
            height: wS * 0.1,
            width: wS * 0.1,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 5,
            ),
          ),
        ),
      ),
    );
  });
}
