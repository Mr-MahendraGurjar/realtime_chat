import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../services/websocket_service.dart';
import '../services/offline_service.dart';

class ChatProvider with ChangeNotifier {
  final WebSocketService _webSocketService = WebSocketService();
  final OfflineService _offlineService = OfflineService();

  List<Chat> _chats = [];
  List<Chat> get chats => _chats;

  bool _isConnected = true;
  bool get isConnected => _isConnected;

  ChatProvider() {
    _init();
  }

  void _init() {
    // Initialize dummy chat
    _chats.add(Chat(id: '1', name: 'PieHost Bot', messages: []));

    // Listen to connectivity
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      bool newConnected = results.any((r) => r != ConnectivityResult.none);

      if (newConnected && !_isConnected) {
        _isConnected = true;
        _connectWebSocket();
        _processOfflineQueue();
      } else if (!newConnected && _isConnected) {
        _isConnected = false;
      }
      notifyListeners();
    });

    // Check initial status
    Connectivity().checkConnectivity().then((results) {
      _isConnected = results.any((r) => r != ConnectivityResult.none);
      if (_isConnected) {
        _connectWebSocket();
      }
      notifyListeners();
    });
  }

  void _connectWebSocket() {
    _webSocketService.connect();
    _webSocketService.stream.listen(
      (data) {
        _handleIncomingMessage(data);
      },
      onError: (error) {
        print("WebSocket Error: $error");
      },
    );
  }

  void _handleIncomingMessage(dynamic data) {
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: data.toString(),
      timestamp: DateTime.now(),
      isMe: false,
    );

    _addMessageToChat('1', message);
  }

  void sendMessage(String chatId, String content) {
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      timestamp: DateTime.now(),
      isMe: true,
      status: _isConnected ? MessageStatus.sent : MessageStatus.sending,
    );

    _addMessageToChat(chatId, message);

    if (_isConnected) {
      _webSocketService.sendMessage(content);
    } else {
      _offlineService.queueMessage(message.id, content);
    }
  }

  void _processOfflineQueue() {
    while (_offlineService.hasMessages) {
      final queuedMsg = _offlineService.dequeue();
      _webSocketService.sendMessage(queuedMsg.content);

      // Update message status to sent
      for (var chat in _chats) {
        final msgIndex = chat.messages.indexWhere((m) => m.id == queuedMsg.id);
        if (msgIndex != -1) {
          chat.messages[msgIndex] = Message(
            id: chat.messages[msgIndex].id,
            content: chat.messages[msgIndex].content,
            timestamp: chat.messages[msgIndex].timestamp,
            isMe: chat.messages[msgIndex].isMe,
            status: MessageStatus.sent,
          );
          notifyListeners();
          break;
        }
      }
    }
  }

  void _addMessageToChat(String chatId, Message message) {
    final chatIndex = _chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      _chats[chatIndex].messages.add(message);
      notifyListeners();
    }
  }
}
