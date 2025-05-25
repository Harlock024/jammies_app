import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WsServices {
  static final WsServices _instance = WsServices._internal();
  factory WsServices() => _instance;
  WsServices._internal();
  late WebSocketChannel _channel;
  bool _connected = false;

  void connected(String userId) {
    if (_connected) return;

    final uri = Uri.parse('ws://localhost:8081/ws?room=');
  }
}
