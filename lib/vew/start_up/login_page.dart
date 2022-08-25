import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app_twitter/utils/authentication.dart';
import 'package:flutter_app_twitter/utils/firestore/users.dart';
import 'package:flutter_app_twitter/vew/screen.dart';
import 'package:flutter_app_twitter/vew/start_up/create_account_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();//入力された情報を取り込む
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(//必須　上の充電とかのあたりには表示させないようにするcolumをラップする
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 50,),
              Text('Mieet',style: TextStyle(color: Colors.orange.shade400,fontSize: 50, fontWeight: FontWeight.bold) ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),//上下に余白を付ける
                child: Container(
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'メールアドレス',
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: passController,
                  decoration: InputDecoration(
                    hintText: 'パスワード',
                  ),
                ),
              ),
              SizedBox(height: 20,),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(text: 'アカウントを作成していない方は'),
                    TextSpan(text: 'こちら',
                      style: TextStyle(color: Colors.blue), 
                      recognizer: TapGestureRecognizer()..onTap =() {//文字をタップすることができ処理を行うことが出来る
                      Navigator.push(context, MaterialPageRoute(builder: ((context) => CreateAccountPage())));
                      }
                    ),
                  ],
                ),
              ),
              SizedBox(height: 70,),
              ElevatedButton(
                onPressed: () async{
                  var result = await Authentication.emailSignIn(email: emailController.text , pass: passController.text );
                  if (result is UserCredential ) {
                    var _result = await UserFirestore.getUser(result.user!.uid);
                    if (_result == true ) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => Screen())));
                    }
                  }
                  //押すと遷移する
                  //pushReplacementで前のログインページに戻る（機能ボタン）がなくなる
                 
                }, child: Text('emailでログイン')
              ),
            ],
          ),
        ),
      ),
    );
  }
}