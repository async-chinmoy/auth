import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome , ${user?.email ?? 'User'}',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'You are successfully logged in!',
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
