import 'package:flutter/material.dart';
import './goal_list_screen.dart';
import './calendar_screen.dart';
import './account_screen.dart';
import './settings_screen.dart';

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
            title: Text('Goals'),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text('Short Term'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => GoalListScreen(/* filter: 'short_term' */),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Middle Term'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => GoalListScreen(/* filter: 'middle_term' */),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Long Term'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => GoalListScreen(/* filter: 'long_term' */),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            title: Text('Calendar'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => CalendarScreen(),
                ),
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
