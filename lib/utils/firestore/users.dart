

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/account.dart';
import '../authentication.dart';

class UserFirestore {
 static final _firestoreInstance = FirebaseFirestore.instance;
 static final CollectionReference users  = _firestoreInstance.collection('users');

 static Future<dynamic> setUser(Account newAccount) async{
     try{
      await users.doc(newAccount.id).set({
         'name': newAccount.name,
         'user_id': newAccount.userId,
         'self_introduction': newAccount.selfintroduction,
         'image_path':newAccount.imagePath,
         'created_time': Timestamp.now(),
         'updated_time': Timestamp.now(),
      });
      return true;
           } on FirebaseException catch(e){
           print(e);
     }
 }
 
 static Future<dynamic> getUser(String uid) async{
  try{
     DocumentSnapshot documentSnapshot = await users.doc(uid).get();
     Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
     Account myAccount = Account(
      id:uid,
      name: data['name'],
      userId: data['user_id'],
      selfintroduction: data['self_introduction'],
      imagePath: data['image_path'],
      createTime: data['created_time'],
      updateTime: data['updated_time']

     );
     Authentication.myAccount = myAccount;
     print('ユーザー取得完了');
     return true;
  } on FirebaseException catch(e){
     print('ユーザー取得エラー: $e');
     return false;
  }
 }
}