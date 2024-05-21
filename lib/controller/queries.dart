import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  static Future<DocumentSnapshot> getCurrentUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    String? currentEmail = user?.email;
    QuerySnapshot usersRef = await firestore.collection('user').get();

    DocumentSnapshot loggedUserData = usersRef.docs.firstWhere(
        (doc) => (doc.data() as Map<String, dynamic>)['email'] == currentEmail);
    return loggedUserData;
  }

  static Future<DocumentReference> getUserDocRef(String? userEmail) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('user')
        .where('email', isEqualTo: userEmail)
        .limit(1)
        .get();
    DocumentReference userRef = querySnapshot.docs[0].reference;
    return userRef;
  }

  static Future<DocumentReference> getBookDocRef(String isbn) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('book')
        .where('isbn', isEqualTo: isbn)
        .limit(1)
        .get();
    DocumentReference bookRef = querySnapshot.docs[0].reference;
    return bookRef;
  }

  static Future<Map<String, dynamic>> getUserData(String? userEmail) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('user')
        .where('email', isEqualTo: userEmail)
        .limit(1)
        .get();
    Map<String, dynamic> userData =
        querySnapshot.docs[0].data() as Map<String, dynamic>;
    return userData;
  }

  static Future<DocumentReference?> getIncompleBookExchange(
      DocumentReference initiatorEmail, DocumentReference receiverEmail) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('incompleteExchanges')
        .where('switchReceiver', isEqualTo: receiverEmail)
        .where('switchInitiator', isEqualTo: initiatorEmail)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    return querySnapshot.docs[0].reference;
  }
}
