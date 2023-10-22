import 'package:http/http.dart' as http;

void addUser(String fullname, String email) async {
   const hostConnect = "http://192.168.1.119/project";
   const getEventsEndpoint = "/insert_user.php";

  final response = await http.post(
    Uri.parse('$hostConnect$getEventsEndpoint'),
    body: {
      'fullname': fullname,
      'email': email,
    },
  );

  if (response.statusCode == 200) {
    print('Response Data: ${response.body}');
    if (response.body == "User added successfully") {
      print('User added successfully');
    } else {
      print('Error: ${response.body}');
    }
  } else {
    print('Failed to connect to the server');
  }
}