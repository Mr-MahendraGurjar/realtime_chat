import 'dart:collection';

class QueuedMessage {
  final String id;
  final String content;

  QueuedMessage({required this.id, required this.content});
}

class OfflineService {
  final Queue<QueuedMessage> _messageQueue = Queue<QueuedMessage>();

  void queueMessage(String id, String content) {
    _messageQueue.add(QueuedMessage(id: id, content: content));
  }

  bool get hasMessages => _messageQueue.isNotEmpty;

  QueuedMessage dequeue() {
    return _messageQueue.removeFirst();
  }

  void clear() {
    _messageQueue.clear();
  }
}
