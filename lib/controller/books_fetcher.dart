import 'dart:convert';

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
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<bool> removeBook(String isbn) async {
    QuerySnapshot querySnapshot =
        await firestore.collection('book').where('isbn', isEqualTo: isbn).get();

    DocumentSnapshot queryUserSnapshot = await Queries.getCurrentUser();

    for (var element in querySnapshot.docs) {
      queryUserSnapshot.reference.update({
        'owns': FieldValue.arrayRemove([element.reference])
      });
    }

    return true;
  }

  Future<List<Book>> fetchUserBookWithImages(String email) async {
    final List<DocumentReference> booksRef =
        await Queries.retrieveUserBooks(email);

    final userID = firebaseAuth.currentUser!.uid;

    final List<String> imageISBN = [];
    for (final bookRef in booksRef) {
      final bookDoc = await bookRef.get();
      try {
        imageISBN.add(bookDoc['isbn']);
      } catch (e) {
        continue;
      }
    }

    final List<Book> images = await Future.wait(imageISBN.map((path) async =>
        Book(
            authors: [],
            genres: [],
            isbn: path,
            lang: '',
            pubYear: '',
            title: '',
            image: await ImageFetcher.getImageByIsbnId(path, userID))));

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
      final List<String> authors = [];
      final List<String> genres = [];

      for (final author in data['authors']) {
        authors.add(author['name']);
      }
      for (final genre in data['subjects']) {
        genres.add(genre['name']);
      }

      return Book(
          authors: authors,
          genres: genres,
          isbn: isbn,
          lang: 'no data',
          pubYear: data['publish_date'] ?? 'no data',
          title: data['title']);
    } else {}
    return Book(
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
      'Language': book.lang,
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
