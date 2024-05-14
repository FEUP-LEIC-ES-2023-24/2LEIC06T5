import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pagepal/controller/queries.dart';
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
          lang: '',
          pubYear: 0,
          title: data['title']);
    } else {}
    return Book(
        authors: [], genres: [], isbn: '', lang: '', pubYear: 0, title: '');
  }

  Future<DocumentReference> addBook(
      String name, String isbn, String author, String imagePath) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    QuerySnapshot authorQuery = await Queries.getAuthor(author);

    DocumentReference authorRef;

    if (authorQuery.docs.isEmpty) {
      authorRef = firestore.collection('author').doc();

      authorRef.set({
        'name': author,
        'wrote': [],
      });
    } else {
      authorRef = authorQuery.docs.first.reference;
    }

    final DocumentReference booksRef = firestore.collection('book').doc();

    booksRef.set({
      'author': authorRef.id,
      'isbn': isbn,
      'title': name,
      'image': imagePath,
    });

    authorQuery = await Queries.getAuthor(author);

    List<String> wrote = await Queries.retrieveAuthorBooks(author);

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
