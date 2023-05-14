import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'variables/ble_variables.dart';
import 'helpers/firebase_auth/firebase_auth_helper.dart';
import 'helpers/reactiveBLE_helpers/ble_device_connector.dart';
import 'helpers/reactiveBLE_helpers/ble_device_interactor.dart';
import 'helpers/reactiveBLE_helpers/ble_scanner.dart';
import 'helpers/reactiveBLE_helpers/ble_status_monitor.dart';

import 'services/local_storage_service.dart';
import 'helpers/global_helper.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/home/home_screen.dart';
import 'state/ble_state.dart';
import 'state/global_state.dart';
import 'config/theme/theme.dart';
import 'widgets/on_pairing_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // set shared preference instance globally
  prefs = await SharedPreferences.getInstance();

  rble = FlutterReactiveBle();

  // know if the user is signed in
  bool firstTime = await getUserStatusFromFirebaseAuth();

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
      home: firstTime ? WelcomeScreen() : HomeScreen(),
      builder: (context, child) {
        return Stack(
          children: [child!, onPairingScreen()],
        );
      },
    );
  }
}
