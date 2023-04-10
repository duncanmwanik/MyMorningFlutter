import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'reactive_state.dart';

class BleStatusMonitor implements ReactiveState<BleStatus?> {
  const BleStatusMonitor(this.rble);

  final FlutterReactiveBle rble;

  @override
  Stream<BleStatus?> get state => rble.statusStream;
}
