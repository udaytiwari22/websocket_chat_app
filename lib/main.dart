import 'package:flutter/material.dart';
import 'chat_screen.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.purple,
          scaffoldBackgroundColor: const Color.fromARGB(255, 225, 131, 242)),
      home: ChatScreen(),
    );
  }
}
