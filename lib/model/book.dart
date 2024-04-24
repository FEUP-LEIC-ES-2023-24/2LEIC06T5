import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
class Book {
  Book({
    required this.authors,
    required this.genres,
    required this.isbn,
    required this.lang,
    required this.pubYear,
    required this.title,
    required this.image,
  });

  final List<DocumentReference> authors;
  final List<String> genres;
  final Image image;
  final String isbn;
  final String lang;
  final String pubYear;
  final String title;


//Get a Book class instance from firebase 
    factory Book.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {


    final data = snapshot.data();
    return Book(
      authors: data?['author'],
      genres: data?['genres'],
      image: data?['image'],
      isbn: data?['isbn'],
      lang: data?['language'],
      pubYear: data?['publicationYear'],
      title: data?['title'],
    );
  }

//TODO possivelmente util para colocar na database
/*
Map<String, dynamic> toFirestore() {
    return {
      if (author != null) "author": author,
      if (genres != null) "genres": genres,
      if (isbn != null) "isbn": isbn,
      if (lang != null) "language": lang,
      if (pubYear != null) "publicationYear": pubYear,
      if (title != null) "title": title,
      if (image != null) "image": image
    };
  }
  */
}
