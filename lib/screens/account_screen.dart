import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${user?.name ?? 'Not provided'}'),
            Text('Email: ${user?.email ?? 'Not provided'}'),
            Text('Password: ${user?.password ?? 'Not provided'}'),
          ],
        ),
      ),
    );
  }
}
