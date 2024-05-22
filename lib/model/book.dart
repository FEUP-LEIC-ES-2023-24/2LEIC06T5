import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pagepal/controller/images_fetcher.dart';
import 'package:pagepal/controller/queries.dart';

class Book {
  Book({
    required this.authors,
    required this.genres,
    required this.isbn,
    required this.lang,
    required this.pubYear,
    required this.title,
    this.image,
    this.ownerEmail,
  });

  final List<dynamic> authors;
  final List<dynamic> genres;
  Image? image;
  final String isbn;
  final String lang;
  final String pubYear;
  final String title;
  String? ownerEmail;

//Get a Book class instance from firebase
  static Future<Book> createBookFromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      String ownerEmail) async {
    final data = snapshot.data();

    String ownerId = (await Queries.getUserDocRef(ownerEmail)).id;
    Future<Image> img = ImageFetcher.getImageByIsbnId(data?['isbn'], ownerId);

    List<String> authors = [];

    for (DocumentReference authorRef in data?['authors']) {
      authors.add((await authorRef.get())['name']);
    }

    return Book(
        authors: authors,
        genres: data?['genres'],
        image: await img,
        isbn: data?['isbn'],
        lang: 'no data',
        pubYear: data?['publicationYear'] ?? 'no data',
        title: data?['title'],
        ownerEmail: ownerEmail);
  }
}
