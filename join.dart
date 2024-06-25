import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
class Join extends StatefulWidget {
  const Join({Key? key}) : super(key: key);

  @override
  _JoinState createState() => _JoinState();
}

class _JoinState extends State<Join> {
  bool _isLoading = false;
  String _message = '';
  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입 페이지'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _idController,
              decoration: InputDecoration(
                hintText: '아이디',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: '비밀번호',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _sendDataToServer,
            child: _isLoading
                ? CircularProgressIndicator()
                : const Text('데이터 전송'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FirstPage()),
              );
            },
            child: Text('홈으로'),
          ),
          SizedBox(height: 16),
          Text(
            _message,
            style: TextStyle(
              color: _message.startsWith('서버로 데이터 전송 성공') ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _sendDataToServer() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    // 서버 URL
    String url = 'http://192.168.0.76:3000/join'; // Adjust the URL for your join endpoint

    // 입력된 아이디와 비밀번호 가져오기
    String id = _idController.text.trim();
    String password = _passwordController.text.trim();

    // 데이터를 JSON 형식으로 만듭니다.
    String jsonData = jsonEncode({'id': id, 'pw': password});

    try {
      // POST 요청 보내기
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      // 요청 완료 후 처리
      if (response.statusCode == 200) {
        setState(() {
          _message = '서버로 데이터 전송 성공: ${response.body}';
        });
        // 성공 시 처리할 코드 추가
      } else {
        setState(() {
          _message = '서버로 데이터 전송 실패: ${response.reasonPhrase}';
        });
        // 실패 시 처리할 코드 추가
      }
    } catch (e) {
      setState(() {
        _message = '서버 연결 오류: $e';
      });
      // 오류 처리
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
