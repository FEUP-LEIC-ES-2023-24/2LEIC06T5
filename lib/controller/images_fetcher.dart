import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class ImageFetcher {
  ImageFetcher();

  final storage = FirebaseStorage.instance;

  Future<Image> getImageByISBN(String isbn) async {
    final ref = storage.ref().child("$isbn.jpg");
    final url = await ref.getDownloadURL();

    return Image(
      image: NetworkImage(url),
    );
  }
}
