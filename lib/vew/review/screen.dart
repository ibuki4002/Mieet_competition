import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app_twitter/model/book.dart';
import 'package:flutter_app_twitter/utils/firestore/books.dart';
import 'package:flutter_app_twitter/vew/review/add_book.dart';
import 'package:flutter_app_twitter/vew/review/review.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  double initialRating = 0;
  int number = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('本の一覧'),
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
      body: StreamBuilder<QuerySnapshot>(
          stream: BookFirestore.books.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('本の登録がありません。'),
              );
            }
            {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  Book newBook = Book(
                    book_name: data['book_name'].toString(),
                    imageUrl: data['imageUrl'].toString(),
                  );
                  FirebaseFirestore.instance
                      .collection('books')
                      .doc(newBook.book_name)
                      .collection('evaluations')
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    querySnapshot.docs.forEach((value) {
                      print(value['rating']);
                      initialRating += value['rating'];
                      number++;
                    });
                  });
                  print(number);
                  initialRating = initialRating / number;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => ReviewPage())));
                    },
                    child: ListTile(
                      title: Text(newBook.book_name),
                      subtitle: RatingBar.builder(
                        initialRating: initialRating.ceil().toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20,
                        ignoreGestures: true,
                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      trailing: GestureDetector(
                          child: CircleAvatar(
                        child: Icon(Icons.add, color: Colors.black),
                        backgroundColor: Color.fromARGB(240, 221, 182, 0),
                      )),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(newBook.imageUrl),
                      ),
                    ),
                  );
                },
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => AddBookPage())));
        },
        child: Icon(Icons.book),
      ),
    );
  }
}
