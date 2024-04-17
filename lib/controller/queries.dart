import 'package:cloud_firestore/cloud_firestore.dart';

class Queries {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<QuerySnapshot> getAuthor(String author) async {
    return await firestore
        .collection('author')
        .where('name', isEqualTo: author)
        .get();
  }

  static Future<List<String>> retrieveAuthorBooks(String author) async {
    QuerySnapshot authorQuery = await getAuthor(author);
    return List.from(
        (authorQuery.docs.first.data() as Map<String, dynamic>)['wrote'] ?? []);
  }

  static Future<QuerySnapshot> getUser(String email) async {
    return await firestore
        .collection('user')
        .where('email', isEqualTo: email)
        .get();
  }

  static Future<List<String>> retrieveUserBooks(String email) async {
    QuerySnapshot userQuery = await getUser(email);
    return List.from(
        (userQuery.docs.first.data() as Map<String, dynamic>)['owns'] ?? []);
  }
}
