import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleDeviceInteractor {
  BleDeviceInteractor({
    required Future<List<DiscoveredService>> Function(String deviceId) bleDiscoverServices,
    required Future<List<int>> Function(QualifiedCharacteristic characteristic) readCharacteristic,
    required Future<void> Function(QualifiedCharacteristic characteristic, {required List<int> value}) writeWithResponse,
    required Future<void> Function(QualifiedCharacteristic characteristic, {required List<int> value}) writeWithOutResponse,
    required Stream<List<int>> Function(QualifiedCharacteristic characteristic) subscribeToCharacteristic,
  })  : rbleDiscoverServices = bleDiscoverServices,
        _readCharacteristic = readCharacteristic,
        _writeWithResponse = writeWithResponse,
        _writeWithoutResponse = writeWithOutResponse,
        _subScribeToCharacteristic = subscribeToCharacteristic;

  final Future<List<DiscoveredService>> Function(String deviceId) rbleDiscoverServices;

  final Future<List<int>> Function(QualifiedCharacteristic characteristic) _readCharacteristic;

  final Future<void> Function(QualifiedCharacteristic characteristic, {required List<int> value}) _writeWithResponse;

  final Future<void> Function(QualifiedCharacteristic characteristic, {required List<int> value}) _writeWithoutResponse;

  final Stream<List<int>> Function(QualifiedCharacteristic characteristic) _subScribeToCharacteristic;

  Future<List<DiscoveredService>> discoverServices(String deviceId) async {
    try {
      final result = await rbleDiscoverServices(deviceId);
      return result;
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<List<int>> readCharacteristic(QualifiedCharacteristic characteristic) async {
    try {
      final result = await _readCharacteristic(characteristic);

      return result;
    } on Exception catch (e, s) {
      print(s);
      rethrow;
    }
  }

  Future<void> writeCharacterisiticWithResponse(QualifiedCharacteristic characteristic, List<int> value) async {
    try {
      await _writeWithResponse(characteristic, value: value);
    } on Exception catch (e, s) {
      // ignore: avoid_print
      print(s);
      rethrow;
    }
  }

  Future<void> writeCharacterisiticWithoutResponse(QualifiedCharacteristic characteristic, List<int> value) async {
    try {
      await _writeWithoutResponse(characteristic, value: value);
    } on Exception catch (e, s) {
      // ignore: avoid_print
      print(s);
      rethrow;
    }
  }

  Stream<List<int>> subScribeToCharacteristic(QualifiedCharacteristic characteristic) {
    return _subScribeToCharacteristic(characteristic);
  }
}
