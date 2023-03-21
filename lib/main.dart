import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // know if the user is signed in
  // bool firstTime = await getUser();
  bool firstTime = false;

  runApp(
    MultiProvider(
      providers: [
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
