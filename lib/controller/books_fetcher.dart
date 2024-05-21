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
          lang: data['Language'],
          image: image,
          pubYear: data['publicationYear'],
          title: data['title']);
    } else {
      return Book(
          mainAuthor: " ",
          authors: [],
          genres: [],
          isbn: '',
          lang: '',
          image: placeholderImage,
          pubYear: '',
          title: '',
          ownerEmail: '');
    }
  }
}
