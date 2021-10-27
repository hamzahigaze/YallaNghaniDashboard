import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yalla_dashboard/helpers/const_data_helper.dart';
import 'package:yalla_dashboard/helpers/ui_helper.dart';
import 'package:yalla_dashboard/providers/token.dart';
import 'package:yalla_dashboard/screens/accounts/accounts_screen.dart';
import 'package:yalla_dashboard/services/api_connection/api_connection_service.dart';
import 'package:yalla_dashboard/services/storage_service/storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var isObscurePassowrd = true;
  var userName = "";
  var password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 40),
          Center(
            child: Image(
              height: 200,
              width: 300,
              image: AssetImage('./assets/images/yalla.png'),
            ),
          ),
          SizedBox(height: 50),
          Center(
            child: Container(
              width: 400,
              child: TextFormField(
                onChanged: (value) {
                  userName = value;
                },
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'اسم المستخدم',
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Center(
            child: Container(
              width: 400,
              child: TextFormField(
                onChanged: (value) {
                  password = value;
                },
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'كلمة المرور',
                  prefixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscurePassowrd = !isObscurePassowrd;
                      });
                    },
                    icon: Icon(
                      isObscurePassowrd
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                obscureText: isObscurePassowrd,
              ),
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: Container(
              width: 100,
              child: ElevatedButton(
                onPressed: login,
                child: Text('دخول'),
              ),
            ),
          )
        ],
      ),
    );
  }

  void login() async {
    if (userName.isEmpty || password.isEmpty) {
      _showDialog('الرجاء عدم ترك حقول فارغة');
      return;
    }
    if (password.length < 8) {
      _showDialog('كلمة المرور يجب أن تكون بطول 8 أحرف');
      return;
    }

    var result = await ApiCaller.request(
      url: '${ConstDataHelper.baseUrl}/auth/adminlogin',
      method: HttpMethod.POST,
      body: jsonEncode({'userName': userName, 'password': password}),
      headers: ConstDataHelper.apiCommonHeaders,
    );

    if (result is Ok) {
      var body = jsonDecode(result.body);
      var token = (body['outcome']['token']) as String;
      if (token != null) {
        TokenProvider().setToken(token);
        await StorageService().write('yalla_admin_token', token);
        print('token was stored');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => AccountsScreen(),
          ),
        );
      } else {
        UIHelper.showMessageDialogWithOkButton(
            context, 'حدث خطأ أثناء تسجيل الدخول');
      }
      return;
    }

    if (result is BadRequest) {
      var body = jsonDecode(result.body);
      if (body['error'] == 'Invalid UserName Or Password')
        UIHelper.showMessageDialogWithOkButton(
            context, 'خطأ في اسم المستخدم أو كلمة المرور');
      else {
        UIHelper.showMessageDialogWithOkButton(
            context, 'حدث خطأ أثناء تسجيل الدخول');
        print(result);
      }
    } else {
      UIHelper.showMessageDialogWithOkButton(
          context, 'حدث خطأ أثناء تسجيل الدخول');
      print(result);
    }
  }

  void _showDialog(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('حسناً'))
            ],
          );
        });
  }
}
