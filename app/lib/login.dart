import 'package:app/book.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'register.dart';
import 'package:shared_preferences/shared_preferences.dart';

final url = "http://localhost:5050";

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  submit() async {
    final res = await http.post(
      Uri.parse("$url/auth/login"),
      headers: {
        "Accept": "application/json",
        'content-type': 'application/json',
        "Access-Control_Allow_Origin": "*"
      },
      body: convert.jsonEncode({
        "username": usernameController.text,
        "password": passwordController.text,
      }),
    );

    if (res.statusCode != 200) {
      showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          children: [
            Center(
              child: Text("Incorrect username or password"),
            )
          ],
        ),
      );
    } else {
      final data = convert.jsonDecode(res.body);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = data["token"];
      await prefs.setString("auth_token", token);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
            ),
            TextButton(onPressed: submit, child: Text("Login")),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text("Register"))
          ],
        ),
      ),
    );
  }
}
