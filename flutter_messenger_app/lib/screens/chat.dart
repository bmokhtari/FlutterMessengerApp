import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_messenger_app/widgets/chat_messages.dart';
import 'package:flutter_messenger_app/widgets/new_messages.dart';

class ChatScreen extends StatelessWidget {

  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fluttenger Chat'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.exit_to_app , 
            color: Theme.of(context).colorScheme.secondary
          ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: const ChatMessages(),
          ),
          const NewMessage(),
        ],
      ),
    );
  }
}