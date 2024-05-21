import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final List<String> likedGenres;
  final GeoPoint location;
  final List<String> owns;
  final String username;

  User(
      {required this.email,
      required this.likedGenres,
      required this.location,
      required this.owns,
      required this.username});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        email: map['email'],
        likedGenres: map['likedGenres'],
        location: map['location'],
        owns: map['owns'],
        username: map['userName']);
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'likedGenres': likedGenres,
      'location': location,
      'owns': owns,
      'userName': username
    };
  }
}
