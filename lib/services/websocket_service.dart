import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final String _url =
      'wss://s15513.nyc1.piesocket.com/v3/1?api_key=whjX1lMZ75KZCzTVJPjfYTf4a6Ro3tCwNXKg9YMM';

  Stream get stream => _channel?.stream ?? Stream.empty();

  void connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_url));
    } catch (e) {
      print("WebSocket connection error: $e");
    }
  }

  void sendMessage(String message) {
    if (_channel != null) {
      _channel!.sink.add(message);
    }
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
