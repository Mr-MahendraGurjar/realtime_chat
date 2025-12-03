import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:realtime_chat/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the first chat and verify chat screen opens', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify we are on the Chat List screen
      expect(find.text('Chats'), findsOneWidget);
      expect(find.text('PieHost Bot'), findsOneWidget);

      // Verify Online status (assuming default is online)
      // Note: On a real device/web, this depends on actual connectivity.
      // We check if either Online or Offline text is present.
      expect(
        find.byIcon(Icons.cloud_done).or(find.byIcon(Icons.cloud_off)),
        findsOneWidget,
      );

      // Tap on the first chat
      await tester.tap(find.text('PieHost Bot'));
      await tester.pumpAndSettle();

      // Verify we are on the Chat Screen
      expect(find.text('PieHost Bot'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Send a message
      await tester.enterText(find.byType(TextField), 'Hello World');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      // Verify message is in the list
      expect(find.text('Hello World'), findsOneWidget);
    });
  });
}
