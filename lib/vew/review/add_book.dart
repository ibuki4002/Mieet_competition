import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app_twitter/model/account.dart';
import 'package:flutter_app_twitter/model/book.dart';
import 'package:flutter_app_twitter/utils/firestore/books.dart';
import 'package:flutter_app_twitter/utils/firestore/evaluations.dart';
import 'package:flutter_app_twitter/utils/function_utils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/evaluation.dart';
import '../../utils/authentication.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  TextEditingController bookNameController = TextEditingController();
  TextEditingController bookAboutController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  double rating_value = 0;

  Account myAccount = Authentication.myAccount!;

  File? image;
  ImagePicker picker = ImagePicker();
  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

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
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    getImageFromGallery();
                  },
                  child: CircleAvatar(
                    foregroundImage: image == null ? null : FileImage(image!),
                    radius: 40,
                    backgroundColor: Color.fromARGB(240, 221, 182, 0),
                    child: Icon(Icons.add),
                  ),
                ),
                Container(
                  width: 300,
                  child: TextField(
                      controller: bookNameController,
                      decoration: InputDecoration(hintText: '本の名前')),
                ),
                SizedBox(height: 15),
                Container(
                  width: 300,
                  child: TextField(
                      controller: bookAboutController,
                      decoration: InputDecoration(hintText: '本の内容')),
                ),
                SizedBox(height: 15),
                Container(
                  width: 300,
                  child: TextField(
                      controller: authorController,
                      decoration: InputDecoration(hintText: '著者名')),
                ),
                SizedBox(height: 15),
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
                    rating_value = rating;
                  },
                ),
                SizedBox(height: 30),
                Container(
                  width: 300,
                  child: TextField(
                      controller: commentController,
                      decoration:
                          InputDecoration(hintText: 'ここにレビューを入力してください')),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(240, 221, 182, 0)),
                    onPressed: () async {
                      if (bookNameController.text.isNotEmpty &&
                          bookAboutController.text.isNotEmpty &&
                          authorController.text.isNotEmpty &&
                          image != null &&
                          rating_value != null &&
                          commentController.text.isNotEmpty) {
                        String imagePath = await FunctionUtils.uploadImage(
                            bookNameController.text, image!);
                        Book newBook = Book(
                          book_name: bookNameController.text,
                          author: authorController.text,
                          book_about: bookAboutController.text,
                          imageUrl: imagePath,
                        );
                        var _result = await BookFirestore.addBook(newBook);
                        Evaluation newEvaluation = Evaluation(
                          comment: commentController.text,
                          rating: rating_value,
                          user_name: myAccount.name,
                        );
                        var _result2 = await EvaluationFirestore.addEvaluation(
                            newEvaluation, newBook);
                        if (_result == true && _result2 == true) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: Text('本の登録'))
              ],
            ),
          ),
        ));
  }
}
