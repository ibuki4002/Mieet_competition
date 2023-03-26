import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddReviewPage extends StatefulWidget {
  const AddReviewPage({super.key});

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  TextEditingController ReviewTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
            title: Text('本の評価'),
                    actions: [
                      IconButton(
                        onPressed: () {
                          // アカウントメニューを表示するためのコード
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(0, kToolbarHeight, 0, 0),
                            items: [
                              PopupMenuItem(
                                value: 'profile',
                                child: Text('プロフィール'),
                              ),
                              PopupMenuItem(
                                value: 'settings',
                                child: Text('設定'),
                              ),
                              PopupMenuItem(
                                value: 'logout',
                                child: Text('ログアウト'),//ログアウト処理入れる
                              ),
                            ],
                          );
                        },
                        icon: Icon(Icons.person),
                      ),
                    ],
                    backgroundColor: Color.fromARGB(240,221,182,0),
                    centerTitle: true,
                    
            ),
      body:Container(
        width:double.infinity,
        child: Column(
          children: [
            SizedBox(height: 30),
            Text('〇〇の評価'),
            SizedBox(height:30),
            RatingBar.builder(
                                      initialRating: 3,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 20,
                                     
                                      itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
            SizedBox(height: 50,),
            Container(
              width:300,
              child: TextField(
                controller: ReviewTextController,
                decoration:InputDecoration(
                  hintText:'レビューを入力',
                )
                
              ),
            ),
            SizedBox(height: 50,),
            ElevatedButton(
              onPressed: (){
                
              },
            child:Text('送信')
             )


          ],
        ),
      ),
      
    );
  }
}