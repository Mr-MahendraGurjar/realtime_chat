import 'package:flutter_test/flutter_test.dart';
import 'package:realtime_chat/services/offline_service.dart';

void main() {
  group('OfflineService', () {
    test('should queue and dequeue messages', () {
      final service = OfflineService();
      service.queueMessage('1', 'msg1');
      service.queueMessage('2', 'msg2');

      expect(service.hasMessages, isTrue);
      expect(service.dequeue().content, 'msg1');
      expect(service.dequeue().content, 'msg2');
      expect(service.hasMessages, isFalse);
    });
  });
}
