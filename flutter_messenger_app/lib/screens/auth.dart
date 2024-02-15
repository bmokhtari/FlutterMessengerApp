import 'dart:html' as html;
import 'dart:io' show File;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_messenger_app/widgets/user_image_picker.dart';

final FirebaseAuth _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoggedIn = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _userPassword = '';
  Uint8List? _selectedImage;
  var _isAuthenticating = false;
  var _username = '';

  void _trySubmit() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid || _selectedImage == null && !_isLoggedIn) {
      return;
    }

    _formKey.currentState?.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (_isLoggedIn) {
        final UserCredential userCredential =
            await _firebase.signInWithEmailAndPassword(
                email: _userEmail, password: _userPassword);
        print(userCredential);
      } else {
        // Sign user up
        final UserCredential userCredential =
            await _firebase.createUserWithEmailAndPassword(
                email: _userEmail, password: _userPassword);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user!.uid}.jpg');
        await storageRef.putData(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': _username,
          'password': _userPassword,
          'email': _userEmail,
          'image_url': imageUrl,
        });
      }
    } on FirebaseAuthException catch (error) {
      var errorMessage = 'An error occurred, please check your credentials.';
      if (error.code == 'email-already-in-use') {
        errorMessage = 'This email is already in use.';
      } else if (error.code == 'weak-password') {
        errorMessage = 'This password is too weak.';
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? 'Authentication failed.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background for a clean look
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 5, // Adds a subtle shadow for depth
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!_isLoggedIn)
                        UserImagePicker(
                          imagePickFn: (Uint8List pickedImage) {
                            _selectedImage = pickedImage;
                          },
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: FlutterLogo(size: 100), // Replace with your logo
                      ),
                      if (!_isLoggedIn)
                      buildTextFormField(
                        key: 'username',
                        labelText: 'Username',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a username.';
                          } else if (value.trim().length < 4) {
                            return 'Username must be at least 4 characters long.';
                          } else if (value.contains(' ')) {
                            return 'Username cannot contain spaces.';
                          }
                          // Add more validation rules if needed
                          return null;
                        },
                        onSaved: (value) => _username = value ?? '',
                      ),
                      buildTextFormField(
                        key: 'email',
                        labelText: 'Email Address',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        onSaved: (value) => _userEmail = value ?? '',
                      ),
                      buildTextFormField(
                        key: 'password',
                        labelText: 'Password',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a password.';
                          } else if (value.trim().length < 8) {
                            return 'Password must be at least 8 characters long.';
                          } else if (value.contains(' ')) {
                            return 'Password cannot contain spaces.';
                          }
                          return null;
                        },
                        onSaved: (value) => _userPassword = value ?? '',
                      ),
                      const SizedBox(height: 20),
                      if (_isAuthenticating) const CircularProgressIndicator(),
                      if (!_isAuthenticating)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue, // Messenger blue color
                            onPrimary: Colors.white,
                            minimumSize:
                                Size(double.infinity, 50), // Full-width button
                          ),
                          onPressed: _trySubmit,
                          child: Text(_isLoggedIn ? 'Login' : 'Sign Up'),
                        ),
                      if (!_isAuthenticating)
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.blue, // Text color
                          ),
                          onPressed: () {
                            setState(() {
                              _isLoggedIn = !_isLoggedIn;
                            });
                          },
                          child: Text(_isLoggedIn
                              ? 'Create new account'
                              : 'I already have an account'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required String key,
    required String labelText,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      key: ValueKey(key),
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(labelText: labelText),
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
