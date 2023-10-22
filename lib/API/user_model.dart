import 'dart:convert';
import 'package:eventapp/API/get_event.dart';
import 'package:http/http.dart' as http;

class UserModel {
  User? user;
  static const hostConnect = "http://192.168.1.119/project";
  static const getEventsEndpoint = "/get_user_model.php";

  Future<void> fetchUserByEmail(String userEmail) async {
    try {
      // Make an API call to retrieve user data based on email
      final user = await getUserByEmail(userEmail);
      // Store the user data in the UserModel
      this.user = user;
      print("user model fetched ");

    } catch (e) {
      // Handle errors, e.g., user not found
      print('Error fetching user data: $e');
    }
  }

  Future<User> getUserByEmail(String userEmail) async {
    final url = Uri.parse('$hostConnect$getEventsEndpoint');

    final response = await http.post(
      url,
      body: {'userEmail': userEmail},
    );
    if (response.statusCode == 200) {
      print('done fetch user data');
      final Map<String, dynamic> data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to fetch user data');

    }
  }
}
class User {
  final int userId;
  final String fullName;
  final String email;
  final List<Event> allEvents;
  final List<Event> createdEvents;
  final List<Event> registeredEvents;

  User({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.allEvents,
    required this.createdEvents,
    required this.registeredEvents,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final int? userId = int.tryParse(json['User']?['UserID'] ?? '');

    final String? fullName = json['User']?['FullName'];

    final String? email = json['User']?['email'];

    final List<dynamic>? allEventsData = json['AllEvents'];
    final List<dynamic>? createdEventsData = json['CreatedEvents'];
    final List<dynamic>? registeredEventsData = json['RegisteredEvents'];

    final List<Event> allEvents = (allEventsData ?? [])
        .map((eventJson) => Event.fromJson(eventJson))
        .toList();
    final List<Event> createdEvents = (createdEventsData ?? [])
        .map((eventJson) => Event.fromJson(eventJson))
        .toList();
    final List<Event> registeredEvents = (registeredEventsData ?? [])
        .map((eventJson) => Event.fromJson(eventJson))
        .toList();

    return User(
      userId: userId ?? 0,
      fullName: fullName ?? '',
      email: email ?? '',
      allEvents: allEvents,
      createdEvents: createdEvents,
      registeredEvents: registeredEvents,
    );
  }
}
