import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'reactive_state.dart';

class BleDeviceConnector extends ReactiveState<ConnectionStateUpdate> {
  BleDeviceConnector({
    required FlutterReactiveBle ble,
  }) : rble = ble;

  final FlutterReactiveBle rble;

  @override
  Stream<ConnectionStateUpdate> get state => _deviceConnectionController.stream;

  final _deviceConnectionController = StreamController<ConnectionStateUpdate>();

  // ignore: cancel_subscriptions
  late StreamSubscription<ConnectionStateUpdate> _connection;

  Future<void> connect(String deviceId) async {
    _connection = rble.connectToDevice(id: deviceId).listen(
      (update) {
        _deviceConnectionController.add(update);
      },
      onError: (Object e) {},
    );
  }

  Future<void> disconnect(String deviceId) async {
    try {
      await _connection.cancel();
    } on Exception catch (e, _) {
    } finally {
      // Since [_connection] subscription is terminated, the "disconnected" state cannot be received and propagated
      _deviceConnectionController.add(
        ConnectionStateUpdate(
          deviceId: deviceId,
          connectionState: DeviceConnectionState.disconnected,
          failure: null,
        ),
      );
    }
  }

  Future<void> dispose() async {
    await _deviceConnectionController.close();
  }
}
