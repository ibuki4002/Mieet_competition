import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String id;
  String name;
  String userId;
  String selfintroduction;
  String imagePath;
  Timestamp? createTime;
  Timestamp? updateTime;

  Account({
    this.id = '',
    this.name='',
    this.userId='',
    this.selfintroduction='',
    this.imagePath='',
    this.createTime,
    this.updateTime,
  });

   
  
}