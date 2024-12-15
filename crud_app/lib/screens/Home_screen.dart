import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  HomeScreen({required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${user.displayName ?? 'User'}!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text('Email: ${user.email ?? 'No email'}'),
          ],
        ),
      ),
    );
  }
}
