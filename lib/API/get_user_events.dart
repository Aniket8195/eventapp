import 'dart:convert';

import 'package:eventapp/API/get_event.dart';
import 'package:http/http.dart' as http;

Future<List<Event>> getUserEvents(int userID) async {
  final url = Uri.parse('http:// 192.168.1.119/project/get_user_events.php'); // Adjust the URL to your PHP script location

  final response = await http.post(
    url,
    body: {'userID': userID.toString()},
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Event.fromJson(json)).toList();
  } else {
    throw Exception('Failed to fetch user events');
  }
}
// class Event {
//   final int eventId;
//   final String title;
//   final String description;
//   final String eventDate;
//   final String eventTime;
//   final int adminUserId;
//
//   Event({
//     required this.eventId,
//     required this.title,
//     required this.description,
//     required this.eventDate,
//     required this.eventTime,
//     required this.adminUserId,
//   });
//
//   factory Event.fromJson(Map<String, dynamic> json) {
//     return Event(
//       eventId: int.parse(json['EventID']),
//       title: json['Title'],
//       description: json['Description'],
//       eventDate: json['EventDate'],
//       eventTime: json['EventTime'],
//       adminUserId: int.parse(json['AdminUserID']),
//     );
//   }
// }