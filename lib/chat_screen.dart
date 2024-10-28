import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  WebSocket? socket;
  TextEditingController _controller = TextEditingController();
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    connect(); // Start WebSocket connection
  }

  Future<void> connect() async {
    try {
      socket = await WebSocket.connect(
          'ws://192.168.29.68:3000'); // **UPDATE this URL to your WebSocket server address**
      socket!.listen(
        onMessageReceived,
        onError: onError,
        onDone: onDisconnected,
      );
    } catch (error) {
      print("Could not connect to WebSocket: $error");
    }
  }

  void onMessageReceived(dynamic message) {
    print("Received message from WebSocket: $message");
    setState(() {
      messages.add("Friend: $message");
    });
  }

  void onError(error) {
    print("Error: $error");
  }

  void onDisconnected() {
    print("Disconnected from WebSocket");
  }

  void sendMessage(String message) {
    if (socket != null && socket!.readyState == WebSocket.open) {
      socket!.add(message);
      print("Sent message: $message"); // Debug statement
      setState(() {
        messages.add("You: $message");
      });
    }
  }

  @override
  void dispose() {
    socket?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat App")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(messages[index]));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: "Send a message"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    sendMessage(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
