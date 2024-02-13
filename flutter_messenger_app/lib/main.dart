import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_messenger_app/screens/chat.dart';
import 'firebase_options.dart';

import 'package:flutter_messenger_app/screens/auth.dart';

void main() {
  // This line makes sure everything is set up before the app starts
  WidgetsFlutterBinding.ensureInitialized();
  
  // Start the app and set up Firebase at the same time
  initializeFirebase();
  runApp(const App());
}

// This is a special function to get Firebase ready for use
Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Setting up how the app looks and feels
    return MaterialApp(
      title: 'Fluttenger', // The name shown at the top
      theme: ThemeData().copyWith(
        useMaterial3: true, // Using the latest design for buttons, boxes, etc.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 63, 17, 177), // Main color of the app
        ),
      ),
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
       builder: (context, snapshot){
        if(snapshot.hasData){
          return const ChatScreen();
        }
       }), // First screen you see in the app
    );
  }
}
