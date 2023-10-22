import 'package:eventapp/API/check_user.dart';
import 'package:eventapp/API/get_event.dart';
import 'package:eventapp/API/user_model.dart';
import 'package:eventapp/Widgets/create_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainFeed extends StatefulWidget {
  const MainFeed({super.key});

  @override
  State<MainFeed> createState() => _MainFeedState();
}

class _MainFeedState extends State<MainFeed> {
  UserModel userModel = UserModel(); // Create an instance of UserModel
  List<Event> createdEventsFeed = [];
  List<Event> allEventsFeed = [];
  Check c= Check();

  @override
  void initState() {
    super.initState();
    final user1 = FirebaseAuth.instance.currentUser;
    if (user1 != null) {
      c.checkUser();
      userModel.fetchUserByEmail(user1.email!).then((_) {
        setState(() {
          print(userModel.user?.email);
          print(userModel.user?.fullName);
          print(userModel.user?.allEvents);
          // createdEventsFeed = userModel.user?.createdEvents ?? [];
          allEventsFeed=userModel.user?.allEvents??[];
        });
      });}

     else {
      // Handle the case where no user is currently authenticated
    }
    // API.getEvents().then((events) {
    //   setState(() {
    //     createdEvents = events;
    //   });
    // }).catchError((error) {
    //   // Handle the error, e.g., display an error message
    //   print('Failed to load events: $error');
    // });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text("UPCOMING EVENTS",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)]),
            ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: ListView.builder(
                itemCount:allEventsFeed.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder:(context,index){
                  return GestureDetector(
                    onTap: (){
                    },
                      child: SizedBox(
                        width: 200,
                        child: Card(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(allEventsFeed[index].title),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.calendar_month_sharp),
                                    Text(allEventsFeed[index].eventDate),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.access_time_filled),
                                    Text(allEventsFeed[index].eventTime),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  );
                  },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child:Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text("EVENTS YOU HOSTING",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)]),
            ),
            Visibility(
              visible: createdEventsFeed.isNotEmpty,
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: ListView.builder(
                  itemCount:createdEventsFeed.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder:(context,index){
                    return GestureDetector(
                      onTap: (){
                      },
                      child: SizedBox(
                        width: 200,
                        child: Card(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(createdEventsFeed[index].title),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.calendar_month_sharp),
                                    Text(createdEventsFeed[index].eventDate),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.access_time_filled),
                                    Text(createdEventsFeed[index].eventTime),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Visibility(
                      visible: createdEventsFeed.isEmpty,
                      child: const Text("No Events Created Yet",style: TextStyle(fontWeight: FontWeight.bold),)),
                ),
              ],
            ),
            Visibility(
              visible: createdEventsFeed.isEmpty,
              child: const SizedBox(
                height: 100,
              ),
            ),
            SizedBox(
              width: 700,
              height: 100,
              child: Padding(
                padding: EdgeInsets.only(left: 20,top: 10,bottom: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>const CreateEvent()));
                      },
                      child: Container(
                        width: 360,
                        decoration: const BoxDecoration(color: Colors.deepOrangeAccent),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("CREATE AN EVENT",style: TextStyle(fontSize:15,color: Colors.white54,fontWeight: FontWeight.bold),),

                                      ),
                                      Icon(Icons.arrow_forward_ios_rounded,color:Colors.white54 ,),
                                    ],
                                  ),
                                ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
