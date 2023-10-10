import 'package:eventapp/Auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         body:
         Container(
           decoration: const BoxDecoration(
             color: Colors.orange,
           ),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,

             children: [
              Center(
                child: GestureDetector(
                  onTap: (){
                    AuthService().signInWithGoogle(context);
                  },
                  child: Container(
                    width: RenderErrorBox.minimumWidth,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 40,
                            height: 40,
                            child: Image.asset(
                                'assets/Images/Google.png')),
                        const Text(
                          "Google",
                          style: TextStyle(
                              fontSize: 16,
                              // Set the text size
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              )
             ],

           ),
         )
      ,
    );
  }
}
