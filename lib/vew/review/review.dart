import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app_twitter/vew/review/add_review.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('本の新規登録'),
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
                    child: Text('ログアウト'), //ログアウト処理入れる
                  ),
                ],
              );
            },
            icon: Icon(Icons.person),
          ),
        ],
        backgroundColor: Color.fromARGB(240, 221, 182, 0),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage(
                            'https://1.bp.blogspot.com/-gZftHjqFY_Y/YVwDNDzrOcI/AAAAAAABfeA/aYJ1ZIgpSmAeLfMT3BSjn5BDEYR8XU1cACNcBGAsYHQ/s180-c/ofuro_sauna_neppashi_woman.png'),
                        fit: BoxFit.cover,
                      ))),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('本のタイトル'), Text('本の説明文')],
                  )
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Color.fromARGB(240, 221, 182, 0), width: 3))),
            child: Text('レビュー'),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://1.bp.blogspot.com/-gZftHjqFY_Y/YVwDNDzrOcI/AAAAAAABfeA/aYJ1ZIgpSmAeLfMT3BSjn5BDEYR8XU1cACNcBGAsYHQ/s180-c/ofuro_sauna_neppashi_woman.png'),
                                ),
                                Text('評価者名'),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  RatingBar.builder(
                                    initialRating: 3,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 20,
                                    ignoreGestures: true,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 1.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                  Text('この本はとても面白かったです。また読んでみたいです。読後感も再興でしたyo。')
                                ],
                              ),
                            )
                          ],
                        ));
                  })),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => AddReviewPage())));
        },
      ),
    );
  }
}
