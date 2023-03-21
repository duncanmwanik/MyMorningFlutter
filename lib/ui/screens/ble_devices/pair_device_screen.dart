import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../logic/ble_logic.dart';
import '../../../_variables/global_variables.dart';
import '../../theme/theme.dart';
import '../../widgets/back_button.dart';
import '../../widgets/toast.dart';

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
                stream: FlutterBluePlus.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!.map((s) {
                    // bool isMyMorningDevice = false;

                    if (s.device.type == BluetoothDeviceType.le) {
                      // s.device.discoverServices().then(
                      //   (services) {
                      //     for (var service in services) {
                      //       if (service.uuid.toString() == serviceUuid) {
                      //         isMyMorningDevice = true;
                      //         print(":::::::::::::::::::::::::::::::::::::true");
                      //       }
                      //     }
                      //   },
                      // );
                      // Future.delayed(Duration(milliseconds: 1000), () {});

                      return StreamBuilder<BluetoothDeviceState>(
                          stream: s.device.state,
                          initialData: BluetoothDeviceState.disconnected,
                          builder: (c, snapshot) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                              onPressed: () async {
                                if (snapshot.data == BluetoothDeviceState.connected) {
                                  selectDevice(context, s.device);
                                } else {
                                  connectDevice(context, widget.firstTime, s.device);
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
                                        // isMyMorningDevice ? 'assets/images/logo.png' : 'assets/images/wearable2.png',
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
                          ));
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
          stream: FlutterBluePlus.instance.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data!) {
              return FloatingActionButton(
                onPressed: () => FlutterBluePlus.instance.stopScan(),
                backgroundColor: primaryColor,
                child: Icon(Icons.stop),
              );
            } else {
              return FloatingActionButton(
                  backgroundColor: primaryColor,
                  child: Icon(Icons.refresh),
                  onPressed: () async {
                    if (await FlutterBluePlus.instance.isOn) {
                      FlutterBluePlus.instance.startScan(timeout: Duration(seconds: 4));
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
