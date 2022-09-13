import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app_twitter/utils/authentication.dart';
import 'package:flutter_app_twitter/utils/firestore/post.dart';
import 'package:flutter_app_twitter/utils/firestore/users.dart';
import 'package:flutter_app_twitter/vew/account/edit_account_page.dart';
import 'package:intl/intl.dart';

import '../../model/account.dart';
import '../../model/post.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Account myAccount = Authentication.myAccount!;
  
  // Account(
  //   id: '1',
  //   name: 'Mieet',
  //   selfIntroduction: 'こんにちは!Mieet登録してね!',
  //   userId: 'mieet_official',
  //   imagePath: 'https://pbs.twimg.com/profile_images/1444908349150011393/i5xLaSGd_400x400.jpg',
  //   createTime: Timestamp.now(),
  //   updateTime: Timestamp.now(),


  // );

// List<Post> postlist = [
//   Post(
//     id: '1',
//     content:'初めまして',
//     postAccountId:'1',
//     createTime: Timestamp.now(),  
//     ),
//     Post(
//     id: '2',
//     content:'初めまして2回',
//     postAccountId:'1',
//     createTime: Timestamp.now(),  
//     ),
// ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView (
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 15, left: 15, top: 20),
                  //color: Colors.red.withOpacity(0.3),
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                foregroundImage: NetworkImage(myAccount.imagePath),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(myAccount.name, style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold),),
                                  Text('@${myAccount.userId}', style: TextStyle(color: Colors.grey.shade600),),
                                ],
                              ),
                            ],
                          ),
                          OutlinedButton(
                            onPressed: () async{
                              var result= Navigator.push(context, MaterialPageRoute(builder: ((context) => EditAccountPage())));
                              if (result == true) {
                                setState(() {
                                  myAccount = Authentication.myAccount!;
                                });
                              }
                            },
                            child: Text('編集'),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(myAccount.selfIntroduction),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,//投稿を真ん中に配置する
                  width: double.infinity,//青い線を横まで延ばす
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      color:Colors.blue, width: 3 
                    ))
                  ),
                  child: Text('投稿',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 16),),
                ),
                Expanded(child: StreamBuilder<QuerySnapshot>(
                  stream: UserFirestore.users.doc(myAccount.id)
                  .collection('my_posts').orderBy('created_time', descending: true)
                  .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<String> myPostIds = List.generate(snapshot.data!.docs.length, (index) {
                        return snapshot.data!.docs[index].id;
                      });
                      return FutureBuilder<List<Post>?>(
                        future: PostFirestore.getPostsFromIds(myPostIds),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            
                          return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: ((context, index) {
                            Post post = snapshot.data![index];
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
                                      foregroundImage: NetworkImage(myAccount.imagePath),
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
                                                    Text(myAccount.name,style: TextStyle(fontWeight:  FontWeight.bold),),
                                                    Text('@${myAccount.userId}',style: TextStyle(color: Colors.green)),
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
                            }
                          ));
                        } else {
                          return Container();
                        }
                        }
                      );
                   } else {
                    return Container();
                   }
                  }
                    
                )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}