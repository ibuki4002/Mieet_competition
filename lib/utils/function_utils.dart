// import 'dart:html';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FunctionUtils {
  static Future<dynamic> getImageFromGallerly() async{
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
    
  }
      
  static Future<String> uploadImage(String uid, File image) async{
      final FirebaseStorage storageInstance = FirebaseStorage.instance;
      final Reference ref =storageInstance.ref();
      await ref.child(uid).putFile(image);
      String downloadUrl = await storageInstance.ref(uid).getDownloadURL();
      print('image_path:$downloadUrl');
      return downloadUrl;
  }
}
// if(pickedFile != null) {
      //   setState(() {
      //     image = File(pickedFile.path);
  //