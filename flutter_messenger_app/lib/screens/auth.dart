import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  void _trySubmit() async {
    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    try {
      if (_isLoggedIn) {
        final UserCredential userCredential = await _firebase.signInWithEmailAndPassword(
          email: _userEmail,
          password: _userPassword
        );
        print(userCredential);
      } else {
        // Sign user up
        final UserCredential userCredential = await _firebase.createUserWithEmailAndPassword(
          email: _userEmail,
          password: _userPassword
        );
        print(userCredential);
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: FlutterLogo(size: 100), // Replace with your logo
                      ),
                      buildTextFormField(
                        key: 'email',
                        labelText: 'Email Address',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty || !value.contains('@')) {
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
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, // Messenger blue color
                          onPrimary: Colors.white,
                          minimumSize: Size(double.infinity, 50), // Full-width button
                        ),
                        onPressed: _trySubmit, 
                        child: Text(_isLoggedIn ? 'Login' : 'Sign Up'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.blue, // Text color
                        ),
                        onPressed: () {
                          setState(() {
                            _isLoggedIn = !_isLoggedIn;
                          });
                        },
                        child: Text(_isLoggedIn ? 'Create new account' : 'I already have an account'),
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
