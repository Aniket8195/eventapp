import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class Check{
  static const hostConnect = "http://192.168.196.35/project";
  static const getEventsEndpoint = "/get_user_model.php";
  late bool isUser;
   checkUser(String userEmail) async{
    final url = Uri.parse('$hostConnect$getEventsEndpoint');
    final user = FirebaseAuth.instance.currentUser;
    String? userEmail;
    if (user != null) {
       userEmail = user.email;
    }
    final response = await http.post(
      url,
      body: {'userEmail': userEmail},
    );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['userExists']) {
          // The user exists, you can access user data using data['User']
         isUser=true;

        } else {
          // The user doesn't exist
          isUser=false;
        }
      }

  }

  }

