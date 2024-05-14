import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:pagepal/model/rating.dart';

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

  static Future<List<DocumentReference>> retrieveUserBooks(String email) async {
    QuerySnapshot userQuery = await getUser(email);
    return List.from(
        (userQuery.docs.first.data() as Map<String, dynamic>)['owns'] ?? []);
  }

  static Future<Rating> getRating(String userID) async {
    final userDocRef = firestore.collection('user').doc(userID);
    QuerySnapshot ratingQuery = await firestore
        .collection('rating')
        .where('userID', isEqualTo: userDocRef)
        .get();
    final rating = ratingQuery.docs.first.data() as Map<String, dynamic>;
    return Rating(rating: rating['rating'], size: rating['size']);
  }

  static void updateRating(String userID, Rating rating, int value) async {
    final double newRating =
        (rating.size * rating.rating + value) / (rating.size + 1);
    print(newRating);
    final userDocRef = firestore.collection('user').doc(userID);
    final ratingDocRef = await firestore
        .collection('rating')
        .where('userID', isEqualTo: userDocRef)
        .get();
    final ratingID = ratingDocRef.docs.first.id;
    firestore.doc('rating/$ratingID').update({
      'rating': double.parse(newRating.toStringAsFixed(2)),
      'size': rating.size + 1,
      'userID': userDocRef
    });
  }
}
