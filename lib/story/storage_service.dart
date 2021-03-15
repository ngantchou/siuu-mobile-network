import 'dart:io';
import 'package:Siuu/story/utilities/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StroageService {
/*  static Future<String> uploadUserProfileImage(
      String url, File imageFile) async {
    String photoId = Uuid().v4();

    if (url.isNotEmpty) {
      //Updating user profile image
      RegExp exp = RegExp(r'userProfile_(.*).jpg');
      photoId = exp.firstMatch(url)[1];
    }
    File image = await compressImage(photoId, imageFile);
    StorageUploadTask uploadTask = storageRef
        .child('images/users/userProfile_$photoId.jpg')
        .putFile(image);
    StorageUploadTask storageSnap = uploadTask.snapshot;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }*/

  static Future<File> compressImage(String photoId, File image) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    File compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$photoId.jpg',
      quality: 70,
    );
    return compressedImageFile;
  }

  static Future<String> _uploadImage(
      String path, String imageId, File image) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(path);
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL =  fileURL;
    });
    return returnURL;
  }

  static Future<String> uploadMessageImage(File imageFile) async {
    String imageId = Uuid().v4();
    File image = await compressImage(imageId, imageFile);

    String downloadUrl = await _uploadImage(
      'images/messages/message_$imageId.jpg',
      imageId,
      image,
    );
    return downloadUrl;
  }

  static Future<String> uploadStoryImage(File imageFile) async {
    String imageId = Uuid().v4();
    File image = await compressImage(imageId, imageFile);

    String downloadUrl = await _uploadImage(
      'images/stories/story_$imageId.jpg',
      imageId,
      image,
    );
    return downloadUrl;
  }
}
