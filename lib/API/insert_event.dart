import 'package:http/http.dart' as http;

Future<void> insertEvent(String title, String description, int adminUserID,String imgurl,String eventDate,String eventTime) async {
  final url = Uri.parse('http://192.168.1.119/project/insert_event.php');
  // final currentDateTime = DateTime.now();
  // final eventDate = '${currentDateTime.year}-${currentDateTime.month.toString().padLeft(2, '0')}-${currentDateTime.day.toString().padLeft(2, '0')}';
  // final eventTime = '${currentDateTime.hour.toString().padLeft(2, '0')}:${currentDateTime.minute.toString().padLeft(2, '0')}';

  final response = await http.post(
    url,
    body: {
      'title': title,
      'description': description,
      'eventDate': eventDate,
      'eventTime': eventTime,
      'adminUserID': adminUserID.toString(),
      'imageURL': imgurl,
    },
  );

  if (response.statusCode == 200) {
    print('${response.body}');
  } else {
    print('Error: ${response.body}');
  }
}
