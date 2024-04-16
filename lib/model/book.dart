import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Book {
  Book(
      {required this.authors,
      required this.genres,
      required this.isbn,
      required this.lang,
      required this.pubYear,
      required this.title,
      this.image = const Image(
        image: AssetImage("assets/dune.jpg"),
      )});

  final List<String> authors; //TODO na firebase authors é só 1
  final List<String> genres;
  final String isbn;
  final String lang;
  final String pubYear;
  final String title;
  final Image image;


//Get a Book class instance from firebase 
    factory Book.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Book(
      authors: data?['author'], //TODO se authors mudar na firebase alterar aqui
      genres: data?['genres'],
      isbn: data?['isbn'],
      lang: data?['language'],
      pubYear: data?['publicationYear'],
      title: data?['title'],
      image: data?['image']
    );
  }

//TODO possivelmente util para colocar na database
Map<String, dynamic> toFirestore() {
    return {
      if (authors != null) "author": authors, //TODO se authors mudar na firebase alterar aqui
      if (genres != null) "genres": genres,
      if (isbn != null) "isbn": isbn,
      if (lang != null) "language": lang,
      if (pubYear != null) "publicationYear": pubYear,
      if (title != null) "title": title,
      if (image != null) "image": image
    };
  }
}


