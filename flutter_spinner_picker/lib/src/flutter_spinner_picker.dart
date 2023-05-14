import 'package:flutter/material.dart';

typedef TimePickerCallback = void Function(DateTime);

class FlutterSpinner extends StatefulWidget {
  final DateTime selectedTime;
  final double? spacing;
  final double? width;
  final double? height;
  final double itemHeight;
  final double itemWidth;
  final double? fontSize;
  final double? suffixSize;
  final Color? selectedFontColor;
  final Color? unselectedFontColor;
  final double padding;
  final Color? color;
  final TimePickerCallback? onTimeChange;

  const FlutterSpinner(
      {this.color = Colors.transparent,
      required this.selectedTime,
      required this.height,
      required this.width,
      this.itemHeight = 20,
      this.itemWidth = 20,
      this.padding = 8,
      this.spacing,
      this.unselectedFontColor = Colors.black26,
      this.selectedFontColor = Colors.black,
      this.fontSize = 26,
      this.suffixSize = 26,
      this.onTimeChange,
      Key? key})
      : super(key: key);

  @override
  State<FlutterSpinner> createState() => _FlutterSpinnerState();
}

class _FlutterSpinnerState extends State<FlutterSpinner> {
  bool isAM = true;
  int _indexLeft = 0;
  int _indexRight = 0;

  Map hours12to24PM = {0: 12, 1: 13, 2: 14, 3: 15, 4: 16, 5: 17, 6: 18, 7: 19, 8: 20, 9: 21, 10: 22, 11: 23, 12: 0};
  Map<int, int> hours24to12 = {12: 0, 13: 1, 14: 2, 15: 3, 16: 4, 17: 5, 18: 6, 19: 7, 20: 8, 21: 9, 22: 10, 23: 11};

  DateTime currentTime = DateTime.now();
  //getter
  DateTime getDateTime() {
    int hour = isAM ? _indexLeft : hours12to24PM[_indexLeft];
    int minute = _indexRight;
    // print("$hour:$minute");
    return DateTime(currentTime.year, currentTime.month, currentTime.day, hour, minute);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _indexLeft = widget.selectedTime.hour >= 12 ? hours24to12[widget.selectedTime.hour]! : widget.selectedTime.hour;
      _indexRight = widget.selectedTime.minute;
      isAM = widget.selectedTime.hour >= 12 ? false : true;
    });
    if (widget.onTimeChange != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => widget.onTimeChange!(getDateTime()));
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width! * 1.2,
      height: widget.height,
      color: widget.color,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: widget.width! / 2.8,
              height: widget.height,
              child: SizedBox(
                height: widget.itemHeight, // card height
                child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller: PageController(viewportFraction: 0.3, initialPage: _indexLeft, keepPage: true),
                  pageSnapping: true,
                  onPageChanged: (int index) => setState(() {
                    int saeat;
                    saeat = index ~/ 12;
                    _indexLeft = index - saeat * (12);
                    if (widget.onTimeChange != null) {
                      widget.onTimeChange!(getDateTime());
                    }
                  }),
                  itemBuilder: (_, i) {
                    int saeat;
                    saeat = i ~/ 12;
                    int hour = i - saeat * 12;
                    return Transform.scale(
                      scale: hour == _indexLeft ? 1.3 : 0.7,
                      child: SizedBox(
                          width: widget.itemWidth,
                          height: widget.itemHeight,
                          child: Center(
                            child: Text(
                              (hour == 0 ? 12 : hour).toString(),
                              style: TextStyle(
                                  color: hour == _indexLeft ? widget.selectedFontColor : widget.unselectedFontColor,
                                  fontSize: widget.fontSize,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              width: widget.spacing,
            ),
            SizedBox(
              width: widget.width! / 2.8,
              height: widget.height,
              child: SizedBox(
                height: widget.itemHeight, // card height
                child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller: PageController(viewportFraction: 0.3, initialPage: _indexRight),
                  onPageChanged: (int index) => setState(() {
                    int daghighe;
                    daghighe = index ~/ 60;
                    _indexRight = index - daghighe * 60;
                    setState(() {
                      if (widget.onTimeChange != null) {
                        widget.onTimeChange!(getDateTime());
                      }
                    });
                  }),
                  itemBuilder: (_, iR) {
                    int daghighe;
                    daghighe = iR ~/ 60;
                    return Transform.scale(
                      scale: iR - daghighe * 60 == _indexRight ? 1.3 : 0.7,
                      child: SizedBox(
                          width: widget.itemWidth,
                          height: widget.itemHeight,
                          child: Center(
                            child: Text(
                              (iR - daghighe * 60).toString().padLeft(2, "0"),
                              style: TextStyle(
                                  color: iR - daghighe * 60 == _indexRight ? widget.selectedFontColor : widget.unselectedFontColor,
                                  fontSize: widget.fontSize,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16), // Row spacing
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => setState(() {
                    isAM = true;
                    if (widget.onTimeChange != null) {
                      widget.onTimeChange!(getDateTime());
                    }
                  }),
                  child: Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(
                      "AM",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: isAM ? widget.selectedFontColor : widget.unselectedFontColor,
                          fontSize: widget.suffixSize,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                InkWell(
                  onTap: () => setState(() {
                    isAM = false;
                    if (widget.onTimeChange != null) {
                      widget.onTimeChange!(getDateTime());
                    }
                  }),
                  child: Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(
                      "PM",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: !isAM ? widget.selectedFontColor : widget.unselectedFontColor,
                          fontSize: widget.suffixSize,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
