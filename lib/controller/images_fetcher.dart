import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class ImageFetcher {
  ImageFetcher();

  static final storage = FirebaseStorage.instance;

  static Future<Image> getImageByIsbnId(String isbn, String ownerId) async {
    var ref = storage.ref().child("${isbn}_$ownerId");

    String url;
    try {
      url = await ref.getDownloadURL();
    } catch (error) {
      ref = storage.ref().child("NoCover.jpg");
      url = await ref.getDownloadURL();
    }

    return Image(
      image: NetworkImage(url),
    );
  }
}
