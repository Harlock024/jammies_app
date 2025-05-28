import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WsServices {
  WebSocketChannel? _channel;
  bool _connected = false;

  Function(Map<String, dynamic>)? onMessage;

  void connect(String userId) {
    if (_connected) return;

    final uri = Uri.parse(
      'ws://jammies-streaming.onrender.com/ws?room_id=$userId',
    );
    print('WS connecting to room $userId');

    _channel = WebSocketChannel.connect(uri);
    _connected = true;

    _channel!.sink.add(jsonEncode({'event': 'join_room'}));
    print('WS connected');

    _channel!.stream.listen(
      (message) {
        final data = jsonDecode(message);
        print('WS mensaje recibido: $data');
        onMessage?.call(data);
      },
      onDone: () {
        print('WS conexión cerrada');
        _connected = false;
      },
      onError: (error) {
        print('WS error: $error');
        _connected = false;
      },
    );
  }

  void sendEvent({
    required String event,
    required String trackId,
    required double currentTime,
  }) {
    if (!_connected || _channel == null) return;

    final msg = jsonEncode({
      'event': event, // "playing" , "paused" o "seek"
      'track_id': trackId,
      'current_time': currentTime,
    });

    print('WS enviando: $msg');
    _channel!.sink.add(msg);
  }

  void disconnect() {
    if (!_connected || _channel == null) return;

    _channel!.sink.close(status.normalClosure);
    _connected = false;
  }
}
