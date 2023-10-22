import 'dart:convert';
import 'package:eventapp/API/insert_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class Check {
  static const hostConnect = "http://192.168.1.119/project";
  static const getEventsEndpoint = "/check_user.php";
  late bool isUser;

  Future<void> checkUser() async {
    final url = Uri.parse('$hostConnect$getEventsEndpoint');
    final user = FirebaseAuth.instance.currentUser;
    String? userEmail;
    String? name;

    if (user != null) {
      userEmail = user.email;
      name = user.displayName;
    }

    final response = await http.post(
      url,
      body: {'userEmail': userEmail},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['userExists']) {
        isUser = true;
      } else {
        // Handle the case where the user doesn't exist in the database
        addUser(name!, userEmail!);
        isUser = false;
      }
    } else {
      // Handle the case where the HTTP request failed
      isUser = false;
    }
  }
}
