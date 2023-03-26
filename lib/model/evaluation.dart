import 'package:cloud_firestore/cloud_firestore.dart';

class Evaluation {
  String user_name;
  double rating;
  String comment;
  Timestamp? createTime;
  Timestamp? updateTime;

  Evaluation({
    this.user_name='',
    this.comment='',
    this.rating=0.0,
    this.createTime,
    this.updateTime,
  });
}