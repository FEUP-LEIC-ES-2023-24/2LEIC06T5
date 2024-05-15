import 'package:pagepal/model/book.dart';

class User {
  User(
      {required this.email,
      required this.username,
      required this.likedGenres,
      required this.books});
  final String email;
  final String username;
  final List<String> likedGenres;
  final List<Book> books;

  User.fromJson(Map<String, Object?> json)
      : this(
          email: json['email']! as String,
          username: json['username']! as String,
          likedGenres: json['likedGenre']! as List<String>,
          books: json['owns']! as List<Book>,
        );

  Map<String, Object?> toJson() {
    return {
      'email': email,
      'username': username,
      'likedGenre': likedGenres,
      'owns': books,
    };
  }
}
