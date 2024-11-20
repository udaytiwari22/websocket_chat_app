import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';

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
          'ws://192.168.29.68:3000'); // Update this URL to your WebSocket server address
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

    // If the message is a string, add it directly
    if (message is String) {
      setState(() {
        messages.add("Friend: $message"); // Add received message as is
      });
    } else if (message is List) {
      // Handle as a fallback if message is an array
      String textMessage = String.fromCharCodes(message as Iterable<int>);
      setState(() {
        messages.add("Friend: $textMessage"); // Add converted message
      });
    }
  }

  void onError(error) {
    print("Error: $error");
  }

  void onDisconnected() {
    print("Disconnected from WebSocket");
  }

  void sendMessage(String message) {
    if (socket != null && socket!.readyState == WebSocket.open) {
      // Send the plain string message
      socket!.add(message);
      print("Sent message: $message");
      setState(() {
        messages.add("You: $message");
      });
      _controller.clear(); // Clear the input field
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
      appBar: AppBar(
        title: const Text(
          "Chat App",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 82, 5, 226),
      ),
      body: Container(
        color: const Color.fromARGB(255, 247, 235, 246), // Light background
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final isMe = messages[index].startsWith("You:");
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isMe
                        ? const Color.fromARGB(255, 136, 103, 246)
                        : Colors.grey[300], // Dark shade for "You" messages
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    messages[index],
                    style: TextStyle(
                        color:
                            isMe ? Colors.white : Colors.black), // Text color
                  ),
                );
              },
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration:
                          const InputDecoration(labelText: "Send a message"),
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
      ),
    );
  }
}
