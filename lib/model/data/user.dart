import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final List<String> likedGenre;
  final GeoPoint location;
  final List<String> owns;
  final String username;

  User({
    required this.email,
    required this.likedGenre,
    required this.location,
    required this.owns,
    required this.username
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'],
      likedGenre: map['likedGenre'],
      location: map['location'],
      owns: map['owns'],
      username: map['username']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email' : email,
      'likedGenre' : likedGenre,
      'location' : location,
      'owns' : owns,
      'username' : username
    };
  }
}