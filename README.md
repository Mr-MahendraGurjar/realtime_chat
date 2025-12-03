# Real-Time Chat App

A Flutter-based real-time chat application featuring offline support, message queuing, and live updates using WebSockets.

## Features

-   **Real-Time Messaging**: Instant message delivery using WebSockets (PieSocket).
-   **Offline Support**:
    -   Messages sent while offline are queued locally.
    -   Automatic synchronization when connection is restored.
    -   Visual indicators for message status (Sending, Sent, Failed).
-   **Optimistic UI**: Messages appear immediately in the chat list before server confirmation.
-   **Message Status Tracking**:
    -   🕒 **Clock**: Sending / Queued (Offline)
    -   ✔️ **Check**: Sent (Server confirmed)
    -   ⚠️ **Error**: Failed to send

## Tech Stack

-   **Framework**: Flutter
-   **State Management**: Provider
-   **Networking**: `web_socket_channel`, `connectivity_plus`
-   **Testing**: `flutter_test`, `integration_test`

## Architecture

The app follows a clean architecture pattern:

-   **Screens**: UI components (`ChatScreen`, `ChatListScreen`).
-   **Providers**: State management logic (`ChatProvider`).
-   **Services**:
    -   `WebSocketService`: Handles real-time socket connections.
    -   `OfflineService`: Manages the offline message queue.
-   **Models**: Data structures (`Message`, `Chat`).

## Key Implementations

### Offline Message Handling
When the device is offline, messages are stored in a `Queue<QueuedMessage>` within `OfflineService`. Each queued message retains its unique ID. Upon reconnection, `ChatProvider` processes this queue, sends the messages via WebSocket, and updates the UI status from "Sending" to "Sent" using the preserved ID.

### Duplicate Message Prevention
The WebSocket connection URL is configured to prevent server echoes (`notify_self=0` implicit), ensuring that sent messages are not received back as new incoming messages, preventing duplication in the UI.

## Getting Started

1.  **Clone the repository**.
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the app**:
    ```bash
    flutter run
    ```

## Testing

Run unit tests for offline service:
```bash
flutter test test/offline_service_test.dart
```
