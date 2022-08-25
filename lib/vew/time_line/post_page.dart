import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController contentController = TextEditingController();//入力した内容をcontentControllerに取得

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('新規投稿',style: TextStyle(color: Colors.black),),
        backgroundColor: Theme.of(context).canvasColor,//色をbodyと同じ色に
        elevation: 2,//影の濃さ
        iconTheme: IconThemeData(color: Colors.black),//白だと背景と同化してしまうので黒に変更
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),//全体の全方向からの間隔
        child: Column(
          children: [
            TextField(
              controller: contentController,//入力したものをcontrollerに代入
            ),
            SizedBox(height: 20,),//縦の間隔
            ElevatedButton(
              onPressed: () {

              },
               child: Text('投稿'),
             ),
          ]
        ),
      ),
    );
  }
}