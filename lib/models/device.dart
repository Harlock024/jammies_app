class Device {
  String deviceId;
  String deviceName;

  Device({required this.deviceId, required this.deviceName});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      deviceId: json['device_id'] as String,
      deviceName: json['device_name'] as String,
    );
  }
}
