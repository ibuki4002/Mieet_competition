import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_twitter/model/book.dart';
import 'package:flutter_app_twitter/model/evaluation.dart';

import '../../model/account.dart';
import '../authentication.dart';

class EvaluationFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;

  static Future<dynamic> addEvaluation(
      Evaluation newEvaluation, Book newBook) async {
    try {
      final CollectionReference _evaluation = _firestoreInstance
          .collection('books')
          .doc(newBook.book_name)
          .collection('evaluations');

      await _evaluation.doc(newEvaluation.user_name).set({
        'rating': newEvaluation.rating,
        'comment': newEvaluation.comment,
      });
      print('評価入力成功！');
      return true;
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
