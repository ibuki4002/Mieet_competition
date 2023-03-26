import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  
  String book_name;
  String imageUrl;
  String author;
  String book_about;
  Timestamp? createTime;
  Timestamp? updateTime;

  Book({
    this.book_name='',
    this.imageUrl='',
    this.author='',
    this.book_about='',
    this.createTime,
    this.updateTime,
  });

   factory Book.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Book(
      book_name: data['book_name'],
      author: data['author'],
      book_about: data['book_about'],
      imageUrl: data['imageUrl'],
     
    );
  }
}