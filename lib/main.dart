import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '_variables/ble_variables.dart';
import 'example/src/ble/ble_device_connector.dart';
import 'example/src/ble/ble_device_interactor.dart';
import 'example/src/ble/ble_scanner.dart';
import 'example/src/ble/ble_status_monitor.dart';

import 'data/preferences.dart';
import 'logic/global_logic.dart';
import 'state/ble_state.dart';
import 'state/global_state.dart';
import 'ui/theme/theme.dart';
import 'ui/screens/home/home_screen.dart';
import 'ui/widgets/on_pairing_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // set shared preference instance globally
  prefs = await SharedPreferences.getInstance();

  rble = FlutterReactiveBle();

  // know if the user is signed in
  // bool firstTime = await getUser();
  bool firstTime = false;

  final scanner = BleScanner(ble: rble);
  final monitor = BleStatusMonitor(rble);
  final connector = BleDeviceConnector(
    ble: rble,
  );
  final serviceDiscoverer = BleDeviceInteractor(
    bleDiscoverServices: rble.discoverServices,
    readCharacteristic: rble.readCharacteristic,
    writeWithResponse: rble.writeCharacteristicWithResponse,
    writeWithOutResponse: rble.writeCharacteristicWithoutResponse,
    subscribeToCharacteristic: rble.subscribeToCharacteristic,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: scanner),
        Provider.value(value: monitor),
        Provider.value(value: connector),
        Provider.value(value: serviceDiscoverer),
        StreamProvider<BleScannerState?>(
          create: (_) => scanner.state,
          initialData: const BleScannerState(
            discoveredDevices: [],
            scanIsInProgress: false,
          ),
        ),
        StreamProvider<BleStatus?>(
          create: (_) => monitor.state,
          initialData: BleStatus.unknown,
        ),
        StreamProvider<ConnectionStateUpdate>(
          create: (_) => connector.state,
          initialData: const ConnectionStateUpdate(
            deviceId: 'Unknown device',
            connectionState: DeviceConnectionState.disconnected,
            failure: null,
          ),
        ),
        ChangeNotifierProvider(create: (context) => GlobalModel()),
        ChangeNotifierProvider(create: (context) => BleModel()),
      ],
      child: MyApp(
        firstTime: firstTime,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({required this.firstTime, super.key});

  final bool firstTime;

  @override
  Widget build(BuildContext context) {
    // create syntax-shortcut variables that point to the respective provider funcions
    createGlobalProviderReferences(context: context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyMorning',
      theme: appTheme,
      home: HomeScreen(),
      // home: firstTime ? HomeScreen() : WelcomeScreen(),
      builder: (context, child) {
        return Stack(
          children: [child!, onPairingScreen()],
        );
      },
    );
  }
}



// class HomeScreen extends StatelessWidget {
//   const HomeScreen({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) => Consumer<BleStatus?>(
//         builder: (_, status, __) {
//           if (status == BleStatus.ready) {
//             return const DeviceListScreen();
//           } else {
//             return BleStatusScreen(status: status ?? BleStatus.unknown);
//           }
//         },
//       );
// }
