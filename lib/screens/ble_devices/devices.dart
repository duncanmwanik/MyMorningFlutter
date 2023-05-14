import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:mymorning/variables/ble_variables.dart';
import 'package:provider/provider.dart';

import '../../variables/global_variables.dart';
import '../../helpers/reactiveBLE_helpers/ble_scanner.dart';
import '../../helpers/ble_helper.dart';
import '../../config/theme/theme.dart';
import '../../../widgets/toast.dart';
import '../home/home_screen.dart';

class Devices extends StatelessWidget {
  const Devices({required this.firstTime, super.key});
  final bool firstTime;

  @override
  Widget build(BuildContext context) => Consumer2<BleScanner, BleScannerState?>(
        builder: (_, bleScanner, bleScannerState, __) => _DeviceList(
          scannerState: bleScannerState ??
              const BleScannerState(
                discoveredDevices: [],
                scanIsInProgress: false,
              ),
          startScan: bleScanner.startScan,
          stopScan: bleScanner.stopScan,
          firstTime: firstTime,
        ),
      );
}

class _DeviceList extends StatefulWidget {
  const _DeviceList({
    required this.scannerState,
    required this.startScan,
    required this.stopScan,
    required this.firstTime,
  });

  final BleScannerState scannerState;
  final void Function(List<Uuid>) startScan;
  final VoidCallback stopScan;
  final bool firstTime;

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<_DeviceList> {
  @override
  void initState() {
    super.initState();
    _startScanning();
  }

  @override
  void dispose() {
    widget.stopScan();
    super.dispose();
  }

  void _startScanning() {
    if (rble.status == BleStatus.poweredOff) {
      toast(0, "Bluetooth is off!");
    } else {
      widget.startScan([]);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () async {
                    if (widget.firstTime) {
                      Navigator.pop(context);
                    } else {
                      await globalWatch.updateSelectedTab(0);
                      Navigator.pushAndRemoveUntil<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => HomeScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    'Select your wearable to pair',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black54),
                  ),
                ],
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Column(
              children: [
                Flexible(
                  child: ListView(
                    children: [
                      ...widget.scannerState.discoveredDevices
                          .map(
                            (device) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                                onPressed: () async {
                                  // print(device.serviceUuids);
                                  connectDevice(context, widget.firstTime, device);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: RotatedBox(
                                        quarterTurns: 3,
                                        child: Image.asset(
                                          'assets/images/wearable2.png',
                                          height: w * 0.15,
                                          width: w * 0.15,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        device.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: primaryColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _startScanning(),
              backgroundColor: primaryColor,
              child: Icon(Icons.refresh),
            )),
      );
}
