import 'package:eventapp/Auth/auth_service.dart';
import 'package:eventapp/Widgets/create_event.dart';
import 'package:eventapp/feed.dart';
import 'package:flutter/material.dart';

int currentIndex = 0;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    //final currentUser = FirebaseAuth.instance.currentUser;
    final List<Widget>screens=[
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
              // Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          )
        ],
      ),

      body: screens[currentIndex],
      bottomNavigationBar:
      NavigationBar(

        selectedIndex:currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentIndex = index;
            print(currentIndex);
          });
        },
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
      ),
    );
  }
}
