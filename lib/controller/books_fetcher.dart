import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:pagepal/controller/queries.dart';
import 'package:pagepal/model/book.dart';

class BooksFetcher {
  BooksFetcher();

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
          pubYear: int.parse(data['publish_date']),
          title: data['title']);
    } else {}
    return Book(
        authors: [], genres: [], isbn: '', lang: '', pubYear: 0, title: '');
  }

  void addBook(String name, String isbn, String author) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
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
    });

    authorQuery = await Queries.getAuthor(author);

    List<String> wrote = await Queries.retrieveAuthorBooks(author);

    wrote.add(booksRef.id);
    authorQuery.docs.first.reference.update({'wrote': wrote});

    QuerySnapshot userQuery =
        await Queries.getUser(auth.currentUser!.email ?? '');

    List<String> owns =
        await Queries.retrieveUserBooks(auth.currentUser!.email ?? '');

    owns.add(booksRef.id);
    userQuery.docs.first.reference.update({'owns': owns});
  }
}
