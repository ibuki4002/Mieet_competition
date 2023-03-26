import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_twitter/model/book.dart';

class BookFirestore{
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference books = _firestoreInstance.collection('books');

  static Future<dynamic> addBook(Book newBook) async{
        try{
             var result = await books.doc(newBook.book_name).set({
                'book_name':newBook.book_name,
                'imageUrl': newBook.imageUrl,
                'author': newBook.author,
                'book_about': newBook.book_about,
                'createTime': newBook.createTime,
                
             });
        } on FirebaseException catch (e){

        }
        return true;
  }




}