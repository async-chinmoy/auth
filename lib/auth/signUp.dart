import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _error = '';

  bool _isPasswordStrong(String pass) {
    if (pass.length < 8) {
      _error = 'Password must be at least 8 characters long.';
      return false;
    }
    return true;
  }

  Future<void> _signUp() async {
    setState(() => _error = '');
    if (!_isPasswordStrong(_passwordController.text.trim())) {
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      if (userCredential.user != null) {
        String userId = userCredential.user!.uid;

        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? 'An unknown error occurred.');
    }
  }

  Future<void> _signUpWithGoogle() async {
    setState(() => _error = '');
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? 'An unknown error occurred.');
    } catch (e) {
      setState(() => _error = 'An unexpected error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Create an Account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  if (_error.isNotEmpty)
                    Text(_error, style: const TextStyle(color: Colors.red)),
                  ElevatedButton(
                    onPressed: _signUp,
                    child: const Text('Create Account'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _signUpWithGoogle,
                    icon: Image.asset('assets/google_logo.png', height: 24.0),
                    label: const Text('Sign Up with Google'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Already have an account? Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
