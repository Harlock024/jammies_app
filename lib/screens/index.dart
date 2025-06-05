import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jammies_app/providers/audio_player.dart';
import 'package:jammies_app/providers/queue_controller.dart';
import 'package:jammies_app/screens/home.dart';

import 'package:jammies_app/screens/library.dart';
import 'package:jammies_app/screens/profile.dart';

import 'package:jammies_app/screens/search.dart';
import 'package:jammies_app/screens/upload.dart';
import 'package:jammies_app/services/devices_services.dart';
import 'package:jammies_app/services/ws_services.dart';
import 'package:jammies_app/widgets/layout/app_layout.dart';
import 'package:jammies_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:volume_controller/volume_controller.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int currentIndex = 0;
  bool showProfile = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (!_initialized) {
      _initialized = true;
      _initDeviceAndWs();
    }
  }

  final _storage = const FlutterSecureStorage();
  Future<void> _initDeviceAndWs() async {
    VolumeController.instance.showSystemUI = true;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final wsServices = Provider.of<WsServices>(context, listen: false);
    final audioController = Provider.of<AudioController>(
      context,
      listen: false,
    );
    final deviceServices = Provider.of<DevicesServices>(context, listen: false);
    final storedDeviceId = await _storage.read(key: 'device_id');

    await userProvider.loadUserFromStorage();
    final user = userProvider.user;
    if (user == null) return;

    String? deviceId = storedDeviceId;

    if (storedDeviceId == null) {
      print('📱 No se encontró device_id, registrando nuevo dispositivo...');
      final success = await deviceServices.addNewDevice();
      if (!success) return;
      deviceId = await _storage.read(key: 'device_id');
    }

    if (deviceId != null) {
      wsServices.connect(deviceId);
      audioController.setWsServices(wsServices);
      wsServices.onMessage = audioController.updateFromWs;
      print('🔌 WS conectado con device_id: $deviceId');
    }
    final queueController = Provider.of<QueueController>(
      context,
      listen: false,
    );
    audioController.queueController = queueController;
    queueController.setAudioController(audioController);
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> pages = [
    HomeScreen(),
    SearchScreen(),
    UploadScreen(),
    LibraryScreen(),
  ];

  void openProfile() {
    setState(() {
      showProfile = true;
    });
    _scaffoldKey.currentState?.closeDrawer();
  }

  void goToTab(int index) {
    setState(() {
      showProfile = false;
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;

        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return AppLayout(
          user: user,
          scaffoldKey: _scaffoldKey,
          onDrawerTap: () => _scaffoldKey.currentState?.openDrawer(),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2D2D2D), // Gris oscuro
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                height: 65,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: currentIndex,
                    onTap: goToTab,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    selectedItemColor:
                        Colors.white, // Color del ítem seleccionado
                    unselectedItemColor:
                        Colors.grey[400], // Color de ítems no seleccionados
                    selectedFontSize: 12,
                    unselectedFontSize: 11,
                    selectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                    items: [
                      BottomNavigationBarItem(
                        icon: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Icon(
                            currentIndex == 0
                                ? Icons.home
                                : Icons.home_outlined,
                            size: 26,
                          ),
                        ),
                        label: "Inicio",
                      ),
                      BottomNavigationBarItem(
                        icon: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Icon(
                            currentIndex == 1
                                ? Icons.search
                                : Icons.search_outlined,
                            size: 26,
                          ),
                        ),
                        label: "Buscar",
                      ),
                      BottomNavigationBarItem(
                        icon: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Icon(
                            currentIndex == 2
                                ? Icons.add_box
                                : Icons.add_box_outlined,
                            size: 26,
                          ),
                        ),
                        label: "Upload",
                      ),
                      BottomNavigationBarItem(
                        icon: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Icon(
                            currentIndex == 3
                                ? Icons.library_music
                                : Icons.library_music_outlined,
                            size: 26,
                          ),
                        ),
                        label: "Biblioteca",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          onProfileTap: openProfile,
          child: showProfile ? ProfileScreen(user: user) : pages[currentIndex],
        );
      },
    );
  }
}
