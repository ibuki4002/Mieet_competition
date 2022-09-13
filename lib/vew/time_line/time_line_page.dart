import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app_twitter/model/account.dart';
import 'package:flutter_app_twitter/model/post.dart';
import 'package:flutter_app_twitter/utils/firestore/post.dart';
import 'package:flutter_app_twitter/utils/firestore/users.dart';
import 'package:flutter_app_twitter/vew/time_line/post_page.dart';
import 'package:intl/intl.dart';

class TimeLinePage extends StatefulWidget {
  const TimeLinePage({Key? key}) : super(key: key);

  @override
  State<TimeLinePage> createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  Account myAccount = Account(
    id: '1',
    name: 'Mieet',
    selfIntroduction: 'こんにちは!Mieet登録してね!',
    userId: 'mieet_official',
    imagePath: 'https://pbs.twimg.com/profile_images/1444908349150011393/i5xLaSGd_400x400.jpg',
    createTime: Timestamp.now(),
    updateTime: Timestamp.now(),


  );

List<Post> postlist = [
  Post(
    id: '1',
    content:'初めまして',
    postAccountId:'1',
    createTime: Timestamp.now(),  
    ),
    Post(
    id: '2',
    content:'初めまして2回',
    postAccountId:'1',
    createTime: Timestamp.now(),  
    ),
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('タイムライン',style: TextStyle(color: Colors.black),),
        backgroundColor: Theme.of(context).canvasColor,//色をbodyと同じ色に
        elevation: 2,//影の濃さ
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: PostFirestore.posts.orderBy('created_time', descending: true).snapshots() ,
        builder: (context, postSnapshot) {
          if (postSnapshot.hasData) {
            List<String> postAccountIds = [];
            postSnapshot.data!.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              if (!postAccountIds.contains(data['post_accont_id'])) {
                postAccountIds.add(data['post_account_id']);
              }
            });

            return FutureBuilder<Map<String,Account>?>(
              future: UserFirestore.getPostUserMap(postAccountIds),
              builder: (context, userSnapshot) {
                if (userSnapshot.hasData && userSnapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                itemCount: postSnapshot.data!.docs.length,//postlistの数
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = postSnapshot.data!.docs[index].data() as Map<String, dynamic>;
                  Post post = Post(
                    id: postSnapshot.data!.docs[index].id,
                    content: data['content'],
                    postAccountId: data['post_account_id'],
                    createTime: data['created_time']
                  );
                  Account postAccount = userSnapshot.data![post.postAccountId]!;
                  return Container(
                    decoration: BoxDecoration(
                      border: index == 0? Border(
                        top: BorderSide(color: Colors.grey,width: 0),
                        bottom: BorderSide(color: Colors.grey,width: 0),
                      ) :Border(bottom: BorderSide(color: Colors.grey,width: 0),),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          foregroundImage: NetworkImage(postAccount.imagePath),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(postAccount.name,style: TextStyle(fontWeight:  FontWeight.bold),),
                                        Text('@${postAccount.userId}',style: TextStyle(color: Colors.green)),
                                      ],
                                    ),
                                    Text(DateFormat('M/d/yy').format(post.createTime!.toDate())),
                                  ],
                                ),
                                Text(post.content),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                      );
                } else {
                  return Container();
                }
                
              }
            );
          } else {
            return Container();
          }
          
        }
      ),
      //tweetボタンの実装
    );
  }
}