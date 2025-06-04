import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jammies_app/models/device.dart';
import 'package:jammies_app/services/api_client.dart';
import 'package:jammies_app/utils/device_utils.dart';

class DevicesServices {
  final _client = ApiClient();
  final _storage = const FlutterSecureStorage();

  Future<bool> addNewDevice() async {
    final response = await _client.post('/device', {
      'device_name': await DeviceUtils.getDeviceName(),
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final deviceId = data['device_id'];
      final deviceName = data['device_name'];

      await _storage.write(key: 'device_id', value: deviceId.toString());
      await _storage.write(key: 'device_name', value: deviceName.toString());
      return true;
    } else {
      throw Exception('Failed to add device');
    }
  }

  Future<List<Device>> getDevices() async {
    final response = await _client.get('/device');

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((json) => Device.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }

  Future<void> deleteDevice() async {
    final deviceId = await _storage.read(key: 'device_id');
    if (deviceId == null) return;
    final response = await _client.delete('/device/$deviceId');
    if (response.statusCode != 204) {
      throw Exception('Failed to delete device');
    }
  }
}
