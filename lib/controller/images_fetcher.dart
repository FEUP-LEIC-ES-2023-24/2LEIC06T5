import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class ImageFetcher {
  ImageFetcher();

  static final storage = FirebaseStorage.instance;

  static Future<Image> getImageByISBN(String isbn) async {

    final ref = storage.ref().child("$isbn.jpg");
    

    final url = await ref.getDownloadURL();

    return Image(
      image: NetworkImage(url),
    );
  }
}