//import 'dart:html';

// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_app_twitter/model/account.dart';
// import 'package:flutter_app_twitter/utils/authentication.dart';
// import 'package:flutter_app_twitter/utils/firestore/users.dart';
// import 'package:flutter_app_twitter/utils/function_utils.dart';
// import 'package:flutter_app_twitter/utils/widget_utils.dart';
// import 'package:image_picker/image_picker.dart';



import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_twitter/model/account.dart';
import 'package:flutter_app_twitter/utils/authentication.dart';
import 'package:flutter_app_twitter/utils/firestore/users.dart';
import 'package:flutter_app_twitter/utils/function_utils.dart';
import 'package:image_picker/image_picker.dart';



class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  TextEditingController nameController = TextEditingController();//入力された情報を取り込む
  TextEditingController useIdController = TextEditingController();
  TextEditingController selfIntoroductionController = TextEditingController();//入力された情報を取り込む
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();//入力された情報を取り込む
  File? image;
  ImagePicker picker = ImagePicker();
  Future<void> getImageFromGallery() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile!= null){
      setState((
      ){ 
        image = File(pickedFile.path);

      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Center(child: Text('新規登録')),
      ),
      body: SingleChildScrollView (
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height:30,),
              GestureDetector(
                onTap:(() {
                  getImageFromGallery();
                }),
                child: CircleAvatar(
                  child: Icon(Icons.add),
                  foregroundImage: image == null ? null : FileImage(image!),
                  radius: 40,
                  backgroundColor: Color.fromARGB(240,221,182,0),
                ),
              ),

              SizedBox(height: 30,),
              
              Container(
                width: 300,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: '名前'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),//上下対称に隙間
                child: Container(
                  width: 300,
                  child: TextField(
                    controller: useIdController,
                    decoration: InputDecoration(hintText: 'ユーザーID'),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: selfIntoroductionController,
                  decoration: InputDecoration(hintText: '自己紹介'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(hintText: 'メールアドレス'),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: passController,
                  decoration: InputDecoration(hintText: 'パスワード'),
                ),
              ),
              SizedBox(height: 50,),
              ElevatedButton(
                onPressed: () async {
                  if(nameController.text.isNotEmpty
                      && useIdController.text.isNotEmpty
                      && selfIntoroductionController.text.isNotEmpty
                      && emailController.text.isNotEmpty
                      && passController.text.isNotEmpty
                      && image != null
                      ) {
                    var result = await Authentication.signUp(email: emailController.text , pass: passController.text );
                      
                    if(result is UserCredential){
                       String imagePath = await FunctionUtils.uploadImage(result.user!.uid, image!);
                       Account newAccount = Account(
                        id: result.user!.uid,
                        name: nameController.text,
                        userId: useIdController.text,
                        selfintroduction: selfIntoroductionController .text,
                        imagePath: imagePath,
                       );
                        var _result = await UserFirestore.setUser(newAccount);
                        if(_result==true){
                           Navigator.pop(context);
                        }
                       
                     }else{
                      
                     }
                    
                  };
                }, 
                child: Text('アカウントを作成')
              ),
            ],
          ),
        ),
      ),
    );
  }
}