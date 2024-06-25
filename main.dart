import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'join.dart'; // Import your Join page if needed
import 'login.dart'; // Import your Login page if needed

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController textEditingController2 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    textEditingController.dispose();
    textEditingController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인 화면'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: '아이디',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: textEditingController2,
              obscureText: true, // Hide password
              decoration: InputDecoration(
                hintText: '비밀번호',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              String id = textEditingController.text.trim();
              String pw = textEditingController2.text.trim();

              String url = 'http://192.168.0.76:3000/login'; // Adjust URL for login endpoint

              String jsonData = jsonEncode({'id': id, 'pw': pw});
              if (id == '0') {
                // Navigate to the successful login page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),);
              }
              try {
                var response = await http.post(
                  Uri.parse(url),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonData,
                );
                if (response.statusCode == 200) {
                  String serverResponse = response.body;
                  if (serverResponse == 'success') {
                    // Navigate to the successful login page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('로그인 실패: 아이디 또는 비밀번호가 일치하지 않습니다.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }}
                else {
                  // Handle server errors
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('서버 오류: ${response.reasonPhrase}'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              } catch (e) {
                // Handle unexpected errors
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('오류 발생: $e'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            child: Text('로그인'),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to the registration page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Join()),
              );
            },
            child: Text('회원가입'),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
      ),
    );
  }
}
