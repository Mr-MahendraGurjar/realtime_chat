enum MessageStatus { sending, sent, failed }

class Message {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isMe;
  MessageStatus status;

  Message({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isMe,
    this.status = MessageStatus.sent,
  });
}
