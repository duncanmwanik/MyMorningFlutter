import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import '../../../methods/ble.dart';
import '../../../methods/globals.dart';
import '../../theme/theme.dart';
import '../../widgets/back_button.dart';
import '../../widgets/on_pairing_view.dart';
import '../../widgets/toast.dart';
import 'pairing_status.dart';

class PairDeviceScreen extends StatefulWidget {
  const PairDeviceScreen({required this.firstTime, super.key});
  final bool firstTime;

  @override
  State<PairDeviceScreen> createState() => _PairDeviceScreenState();
}

class _PairDeviceScreenState extends State<PairDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // stream a list of all BLE devices that are advertising
            Expanded(
              child: StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!.map((s) {
                    if (s.device.type == BluetoothDeviceType.le) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                          onPressed: () async {
                            bool success = await connectDevice(s.device);
                            if (success) {
                              await globalWatch.showOnPairing(false);

                              if (widget.firstTime) {
                                Navigator.pushAndRemoveUntil<dynamic>(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) => PairingStatusScreen(success: success),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                Navigator.pop(context);
                              }
                            } else {
                              await globalWatch.showOnPairing(false);
                              toast(0, "Failed to connect device!");
                            }
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
                                  s.device.name,
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
                      );
                    } else {
                      return Container();
                    }
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: StreamBuilder<bool>(
          stream: FlutterBlue.instance.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data!) {
              return FloatingActionButton(
                onPressed: () => FlutterBlue.instance.stopScan(),
                backgroundColor: primaryColor,
                child: Icon(Icons.stop),
              );
            } else {
              return FloatingActionButton(
                  backgroundColor: primaryColor,
                  child: Icon(Icons.refresh),
                  onPressed: () async {
                    if (await FlutterBlue.instance.isOn) {
                      FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
                    } else {
                      toast(0, "Bluetooth is off!");
                    }
                  });
            }
          },
        ),
      ),
    );
  }
}
