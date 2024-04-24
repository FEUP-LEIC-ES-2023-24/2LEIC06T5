import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pagepal/controller/images_fetcher.dart';

import 'package:pagepal/model/book.dart';

class BooksFetcher {
  BooksFetcher();
  final imageFetcher = ImageFetcher();
  final placeholderImage = const Image(image: AssetImage('assets/dune.jpg'));


  Future<Book> searchBookByISBN(String isbn) async {
    final url = Uri.https('openlibrary.org', '/api/books',
        {'bibkeys': 'ISBN:$isbn', 'format': 'json', 'jscmd': 'data'});

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(response.body)['ISBN:$isbn'];
      final List<DocumentReference> authors = [];
      final List<String> genres = [];

      final image = await imageFetcher.getImageByISBN(isbn);


      for (final author in data['authors']) {
        authors.add(author);
      }
      for (final genre in data['subjects']) {
        genres.add(genre['name']);
      }

      return Book(
          authors: authors,
          genres: genres,
          isbn: isbn,
          lang: '',
          image: image,
          pubYear: data['publish_date'],
          title: data['title']);
    } else {}
    return Book(
        authors: [],
        genres: [],
        isbn: '',
        lang: '',
        image: placeholderImage,
        pubYear: '',
        title: '');
  }
}
