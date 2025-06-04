import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jammies_app/models/device.dart';
import 'package:jammies_app/services/devices_services.dart';
import 'package:provider/provider.dart';

void showDevicesBottomSheet(
  BuildContext context,
  Function(Device) onSelect,
) async {
  final storage = const FlutterSecureStorage();
  final currentDeviceId = await storage.read(key: 'device_id');

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Device>>(
          future:
              Provider.of<DevicesServices>(context, listen: false).getDevices(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return SizedBox(
                height: 200,
                child: Center(child: Text('Error: ${snapshot.error}')),
              );
            }

            final devices = snapshot.data ?? [];

            // Separa el dispositivo actual del resto
            final currentDevice = devices.firstWhere(
              (d) => d.deviceId == currentDeviceId,
              orElse:
                  () => Device(
                    deviceId: currentDeviceId!,
                    deviceName: 'Este dispositivo',
                  ),
            );

            final otherDevices =
                devices.where((d) => d.deviceId != currentDeviceId).toList();

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dispositivos vinculados',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.phone_android),
                  title: const Text('Este dispositivo'),
                  subtitle: Text(
                    currentDevice.deviceName ?? 'Nombre desconocido',
                  ),
                ),
                if (otherDevices.isNotEmpty) ...[
                  const Divider(),
                  const Text(
                    'Otros dispositivos',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...otherDevices.map((device) {
                    return ListTile(
                      leading: const Icon(Icons.devices_other),
                      title: Text(
                        device.deviceName ?? 'Dispositivo sin nombre',
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        onSelect(device);
                      },
                    );
                  }),
                ] else
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('No hay otros dispositivos.'),
                  ),
              ],
            );
          },
        ),
      );
    },
  );
}
