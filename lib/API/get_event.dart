import 'dart:convert';
import 'package:http/http.dart' as http;

class API {
  static const hostConnect = "http://192.168.196.35/project";
  static const getEventsEndpoint = "/get_event.php";

  static Future<List<Event>> getEvents() async {
    final response = await http.get(Uri.parse('$hostConnect$getEventsEndpoint'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
}
class Event {
  final int eventId;
  final String title;
  final String description;
  final String eventDate;
  final String eventTime;
  final int adminUserId;

  Event({
    required this.eventId,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.eventTime,
    required this.adminUserId,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: int.parse(json['EventID']),
      title: json['Title'],
      description: json['Description'],
      eventDate: json['EventDate'],
      eventTime: json['EventTime'],
      adminUserId: int.parse(json['AdminUserID']),
    );
  }
}

