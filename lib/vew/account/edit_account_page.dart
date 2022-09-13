import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app_twitter/model/account.dart';
import 'package:flutter_app_twitter/utils/authentication.dart';
import 'package:flutter_app_twitter/utils/firestore/users.dart';
import 'package:flutter_app_twitter/utils/function_utils.dart';
import 'package:flutter_app_twitter/utils/widget_utils.dart';
import 'package:flutter_app_twitter/vew/start_up/login_page.dart';
import 'package:image_picker/image_picker.dart';


class EditAccountPage extends StatefulWidget {
  const EditAccountPage({Key? key}) : super(key: key);

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  Account myaccount = Authentication.myAccount!;
  TextEditingController nameController = TextEditingController();//入力された情報を取り込む
  TextEditingController useIdController = TextEditingController();
  TextEditingController selfIntoroductionController = TextEditingController();//入力された情報を取り込む
  File? image;

ImageProvider getImage(){
  if (image == null) {
    return NetworkImage(myaccount.imagePath);
  }else {
    return FileImage(image!);
  }
}


  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: myaccount.name);
    useIdController = TextEditingController(text: myaccount.userId);
    selfIntoroductionController = TextEditingController(text: myaccount.selfIntroduction);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('プロフィール編集'),
      body: SingleChildScrollView (
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 30,),
              GestureDetector(
                
                onTap: (() async{
                  var result = FunctionUtils.getImageFromGallerly();
                  if (result != null) {
                    setState(() {
                      image = File(result.path);//何でエラーになっちゃうんだ
                    });
                  }
                }),
               

                child: CircleAvatar(
                  foregroundImage: getImage(),
                  radius: 40,
                  child: Icon(Icons.add),
                ),
              ),
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
              
              SizedBox(height: 50,),
              ElevatedButton(
                onPressed: () async {
                  if(nameController.text.isNotEmpty
                      && useIdController.text.isNotEmpty
                      && selfIntoroductionController.text.isNotEmpty) {
                    String imagePath = '';
                    if (image == null) {
                      imagePath = myaccount.imagePath;
                    } else {
                      var result = await FunctionUtils.uploadImage(myaccount.id, image!);
                      imagePath = result;
                    }
                    Account updateAccount = Account(
                      id: myaccount.id,
                      name: nameController.text,
                      userId: useIdController.text,
                      selfIntroduction: selfIntoroductionController.text,
                      imagePath: imagePath
                    );
                    Authentication.myAccount = updateAccount;
                    var result = await UserFirestore.updateUser(updateAccount);
                    if (result == true) {
                      Navigator.pop(context, true);
                    }

                  };
                }, 
                child: Text('更新')
              ),
              SizedBox(height: 50,),
              ElevatedButton(onPressed: () {
                Authentication.signOut();
                while (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => LoginPage()
                  ));
              },
              child: Text('ログアウト')
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red),
              onPressed: () {
                UserFirestore.deleteUser(myaccount.id);
                Authentication.deleteAuth();
                while (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => LoginPage()
                  ));
              },
              child: Text('アカウントを削除')
            ),
            ],
          ),
        ),
      ),
    );
  }
}