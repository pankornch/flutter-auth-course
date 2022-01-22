import 'package:app/login.dart';
import 'package:flutter/material.dart';

class RegisterScreeen extends StatefulWidget {
  const RegisterScreeen({Key? key}) : super(key: key);

  @override
  _RegisterScreeenState createState() => _RegisterScreeenState();
}

class _RegisterScreeenState extends State<RegisterScreeen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  void submit() {
    print(usernameController.text);
    print(passwordController.text);

    if (passwordConfirmController.text != passwordController.text) {
      showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          children: [
            Center(
              child: Text("Password not matched!"),
            ),
          ],
        ),
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: passwordConfirmController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Re-type Password',
              ),
            ),
            SizedBox(height: 24),
            TextButton(
              onPressed: submit,
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
