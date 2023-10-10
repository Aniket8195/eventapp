import 'package:eventapp/API/create_event.dart';
import 'package:eventapp/Auth/auth_service.dart';
import 'package:eventapp/feed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;
    final currentUser = FirebaseAuth.instance.currentUser;
    final List<Widget>_screens=[
      const MainFeed(),
      const CreateEvent(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("WELCOME",style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.deepOrange,
            ),
            onPressed: () {
              AuthService().signOut(context);
              Navigator.pop(context);
            },
          )
        ],
      ),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.amber[800],
        destinations:const <NavigationDestination> [
          NavigationDestination(
            selectedIcon:  Icon(Icons.home_outlined),
            icon:Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.create_outlined),
            icon: Icon(Icons.create),
            label: 'Create',
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedIndex:_currentIndex,

        animationDuration: const Duration(microseconds:600),
      ),
      body: _screens[_currentIndex],
    );
  }
}
