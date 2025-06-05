import 'dart:convert';
import 'package:jammies_app/services/api_url.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WsServices {
  WebSocketChannel? _channel;
  bool _connected = false;
  String currentRoomId = '';

  Function(Map<String, dynamic>)? onMessage;

  void connect(String deviceId, {void Function()? onConnected}) {
    if (_connected) {
      disconnect();
    }

    final uri = Uri.parse('$WsUrl/ws?room_id=$deviceId');
    print('uri connected $uri');
    print('WS connecting to room $deviceId');

    _channel = WebSocketChannel.connect(uri);
    _connected = true;
    currentRoomId = deviceId;

    _channel!.sink.add(jsonEncode({'event': 'join_room'}));
    print('WS connected');

    bool hasCalledOnConnected = false;

    _channel!.stream.listen(
      (message) {
        final data = jsonDecode(message);
        print('WS mensaje recibido: $data');
        onMessage?.call(data);

        if (!hasCalledOnConnected && onConnected != null) {
          hasCalledOnConnected = true;
          onConnected();
        }
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
    String? targetRoom,
  }) {
    if (!_connected || _channel == null) return;

    final msg = {
      'event': event,
      'track_id': trackId,
      'current_time': currentTime,
    };

    if (targetRoom != null) {
      msg['target_room'] = targetRoom;
    }

    _channel!.sink.add(jsonEncode(msg));
  }

  void sendRawJson(Map<String, dynamic> json) {
    if (!_connected || _channel == null) return;
    _channel!.sink.add(jsonEncode(json));
  }

  void disconnect() {
    if (!_connected || _channel == null) return;

    _channel!.sink.close(status.normalClosure);
    _connected = false;
  }
}
