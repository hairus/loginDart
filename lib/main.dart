import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: Login(),
  ));
}

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String username, password;
  final _key = new GlobalKey<FormState>();

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response = await http.post(
        "http://192.168.2.3/laravel_android/public/api/login",
        body: {"email": username, "password": password});
    final data = jsonDecode(response.body);
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return 'user tidak boleh kosong';
                }
              },
              onSaved: (e) => username = e,
              decoration: InputDecoration(labelText: "username"),
            ),
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return 'password tidak boleh kosong';
                }
              },
              obscureText: true,
              onSaved: (e) => password = e,
              decoration: InputDecoration(labelText: "password"),
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}
