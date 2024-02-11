
import 'package:flutter/material.dart';
import 'package:todolog/screens/report_screen.dart';

import '../screens/home_screen.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Text('To Do Tracker'),
          ),
          ListTile(
            title: const Text('Задачи'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()),);
            },
          ),
          ListTile(
            title: const Text('Журнал'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Reportscreen()),);
            },
          ),
          ListTile(
            title: const Text('Шаблоны'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}