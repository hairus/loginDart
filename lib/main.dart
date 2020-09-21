import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String username, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

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
    bool success = data['success'];
    String token = data['token'];
    if (success == true) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(token);
      });
      print(token);
      print('ini sukses login');
    } else {
      print('tidak cocok');
    }
  }

  savePref(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("token", value);
      preferences.commit();
    });
  }

  var token;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("token");

      _loginStatus = token != null ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
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
                  obscureText: _secureText,
                  onSaved: (e) => password = e,
                  decoration: InputDecoration(
                    labelText: "password",
                    suffixIcon: IconButton(
                      onPressed: showHide,
                      icon: Icon(_secureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
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
        break;
      case LoginStatus.signIn:
        return MainMenu();
        break;
    }
  }
}

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Menu utama"),
      ),
    );
  }
}
