import 'package:flutter/material.dart';
import './goal_list_screen.dart';
import './calendar_screen.dart';
import './account_screen.dart';
import './settings_screen.dart';
import './login_screen.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
           ListTile(
            title: Text('Kısa Vadeli Goals'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => GoalListScreen('Kısa Vadeli')),
              );
            },
          ),
          ListTile(
            title: Text('Orta Vadeli Goals'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => GoalListScreen('Orta Vadeli')),
              );
            },
          ),
          ListTile(
            title: Text('Uzun Vadeli Goals'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => GoalListScreen('Uzun Vadeli')),
              );
            },
          ),
          ListTile(
            title: Text('Calendar'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CalendarScreen()),
              );
            },
          ),
          ListTile(
            title: Text('My Account'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AccountScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
