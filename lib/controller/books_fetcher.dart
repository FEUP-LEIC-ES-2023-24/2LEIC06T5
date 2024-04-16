import 'dart:convert';

import 'package:http/http.dart' as http;
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
          pubYear: data['publish_date'],
          title: data['title']);
    } else {}
    return Book(
        authors: [], genres: [], isbn: '', lang: '', pubYear: '', title: '');
  }
}
