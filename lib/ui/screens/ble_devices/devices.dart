import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

import '../../../_variables/global_variables.dart';
import '../../../example/src/ble/ble_scanner.dart';
import '../../../example/src/widgets.dart';
import '../../../example/src/ui/device_detail/device_detail_screen.dart';
import '../../../logic/ble_logic.dart';
import '../../theme/theme.dart';
import '../../widgets/back_button.dart';

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
    widget.startScan([]);
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
              leading: customBackButton(context, Colors.black54),
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
