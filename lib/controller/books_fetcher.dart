import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pagepal/controller/queries.dart';
import 'package:flutter/cupertino.dart';
import 'package:pagepal/controller/images_fetcher.dart';
import 'package:pagepal/model/book.dart';

class BooksFetcher {
  BooksFetcher();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Image>> fetchUserBookImages(String email) async {
    final List<DocumentReference> booksRef =
        await Queries.retrieveUserBooks(email);

    final List<String> imagePaths = [];
    for (final bookRef in booksRef) {
      final bookDoc = await bookRef.get();
      imagePaths.add(bookDoc['image']);
    }

    final List<Image> images =
        imagePaths.map((path) => Image.file(File(path))).toList();
    return images;
  }

  final imageFetcher = ImageFetcher();
  final placeholderImage = const Image(image: AssetImage('assets/dune.jpg'));

  Future<Book> searchBookByISBN(String isbn) async {
    final url = Uri.https('openlibrary.org', '/api/books',
        {'bibkeys': 'ISBN:$isbn', 'format': 'json', 'jscmd': 'data'});

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(response.body)['ISBN:$isbn'];
      final List<dynamic> authors = [];
      final List<dynamic> genres = [];

      final image = await ImageFetcher.getImageByIsbnId(isbn, "_");

      for (final author in data['authors']) {
        authors.add(author);
      }
      for (final genre in data['subjects']) {
        genres.add(genre['name']);
      }

      DocumentSnapshot authorSnapshot = await (data['authors'][0]).get();
      final Map<String, dynamic> authorData =
          authorSnapshot.data() as Map<String, dynamic>;
      String mainAuthorName = authorData["name"];

      return Book(
          authors: authors,
          mainAuthor: mainAuthorName,
          genres: genres,
          isbn: isbn,
          image: image,
          lang: '',
          pubYear:
              data['publish_date'] != "" ? data['publish_date'] : 'no data',
          title: data['title']);
    } else {}
    return Book(
      mainAuthor: '',
      authors: [],
      genres: [],
      isbn: '',
      lang: '',
      pubYear: '',
      title: '',
    );
  }

  Future<DocumentReference> addBook(Book book) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    QuerySnapshot authorQuery = await Queries.getAuthor(book.authors[0]);

    DocumentReference authorRef;

    if (authorQuery.docs.isEmpty) {
      authorRef = firestore.collection('author').doc();

      authorRef.set({
        'name': book.authors[0],
        'wrote': [],
      });
    } else {
      authorRef = authorQuery.docs.first.reference;
    }

    final DocumentReference booksRef = firestore.collection('book').doc();

    booksRef.set({
      'authors': [authorRef],
      'isbn': book.isbn,
      'title': book.title,
      'publicationYear': book.pubYear,
      'genres': book.genres,
    });

    authorQuery = await Queries.getAuthor(book.authors[0]);

    List<String> wrote = await Queries.retrieveAuthorBooks(book.authors[0]);

    wrote.add(booksRef.id);
    authorQuery.docs.first.reference.update({'wrote': wrote});

    QuerySnapshot userQuery =
        await Queries.getUser(auth.currentUser!.email ?? '');

    List<DocumentReference> owns =
        await Queries.retrieveUserBooks(auth.currentUser!.email ?? '');

    owns.add(booksRef);
    userQuery.docs.first.reference.update({'owns': owns});

    return booksRef;
  }
}
