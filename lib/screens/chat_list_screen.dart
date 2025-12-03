import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    children: [
                        Text(chatProvider.isConnected ? "Online" : "Offline", style: TextStyle(fontSize: 12)),
                        SizedBox(width: 5),
                        Icon(
                            chatProvider.isConnected ? Icons.cloud_done : Icons.cloud_off,
                            color: chatProvider.isConnected ? Colors.green : Colors.red,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.chats.isEmpty) {
            return Center(child: Text('No chats available'));
          }
          return ListView.builder(
            itemCount: chatProvider.chats.length,
            itemBuilder: (context, index) {
              final chat = chatProvider.chats[index];
              return ListTile(
                leading: CircleAvatar(child: Text(chat.name[0])),
                title: Text(chat.name),
                subtitle: Text(
                  chat.lastMessage?.content ?? 'No messages',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(chatId: chat.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
