import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:pagepal/model/book.dart';
import 'package:pagepal/controller/queries.dart';
import 'package:geocoding/geocoding.dart';

double degreesToRadians(double degree) {
  return degree * pi / 180.0;
}

Future<bool> isWithinDistance(double userLat, double userLon, double otherLat,
    double otherLon, double distance) async {
  otherLat = degreesToRadians(otherLat);
  otherLon = degreesToRadians(otherLon);
  userLat = degreesToRadians(userLat);
  userLon = degreesToRadians(userLon);

  double deltaLat = otherLat - userLat;
  double deltaLon = otherLon - userLon;

  double aux = (sin(deltaLat / 2) * sin(deltaLat / 2)) +
      cos(otherLat) * cos(userLat) * (sin(deltaLon / 2) * sin(deltaLon / 2));
  double c = 2.0 * atan2(sqrt(aux), sqrt(1.0 - aux));
  //earth radius: 6371000 meters
  return (c * 6371000) < distance;
}

Future<List<DocumentReference>> getNearbyUsers() async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  QuerySnapshot usersRef = await db.collection('user').get();

  Map<String, dynamic> loggedUserData =
      (await Queries.getCurrentUser()).data() as Map<String, dynamic>;
  String currentEmail = loggedUserData['email'];

  GeoPoint originGeoPoint = loggedUserData['Location'];

  List<DocumentReference> allCloseUsers = [];

  for (DocumentSnapshot userDoc in usersRef.docs) {
    var userData = userDoc.data() as Map<String, dynamic>;
    GeoPoint geoPoint = userData['Location'];

    if ((userData['email'] != currentEmail) &&
        (await isWithinDistance(
            originGeoPoint.latitude,
            originGeoPoint.longitude,
            geoPoint.latitude,
            geoPoint.longitude,
            60))) {
      allCloseUsers.add((await Queries.getUserDocRef(userData['email'])));
    }
  }
  return allCloseUsers;
}

Future<List<DocumentReference>> getPairedUsers(
    DocumentReference currentUser) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<DocumentReference> pairedUsers = [];

  QuerySnapshot bookEchanges = await db
      .collection('incompleteExchanges')
      .where('switchReceiver', isEqualTo: currentUser)
      .get();

  for (DocumentSnapshot bookEchange in bookEchanges.docs) {
    Map<String, dynamic> bookExchangeData =
        bookEchange.data() as Map<String, dynamic>;
    pairedUsers.add(bookExchangeData['switchInitiator']);
  }

  return pairedUsers;
}

Future<Book> getBookFromRef(DocumentReference bookRef,
    [String ownerEmail = "_"]) async {
  DocumentSnapshot<Map<String, dynamic>> bookData =
      await bookRef.get() as DocumentSnapshot<Map<String, dynamic>>;

  Book book = await Book.createBookFromFirestore(bookData, ownerEmail);
  return book;
}

Future<List<Book>> getUsersBooks(
    List<DocumentReference> pairedUsers, List<dynamic> ownedBooks) async {
  List<Book> pairedBooks = [];

  for (DocumentReference userRef in pairedUsers) {
    Map<String, dynamic> userData =
        (await userRef.get()).data() as Map<String, dynamic>;
    for (DocumentReference bookRef in userData['owns']) {
      bool isOwned = ownedBooks.any((ref) => ref == bookRef);
      if (!isOwned) {
        Book newBook = await getBookFromRef(bookRef, userData['email']);
        pairedBooks.add(newBook);
      }
    }
  }
  return pairedBooks;
}

Future<List<Book>> getNearbyUsersBooks() async {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  DocumentReference currentUserDocRef =
      await Queries.getUserDocRef(currentUser?.email);
  List<DocumentReference> pairedUsers = await getPairedUsers(currentUserDocRef);

  List<DocumentReference> nearbyUsers = await getNearbyUsers();

  for (DocumentReference nearbyUser in nearbyUsers) {
    if (!pairedUsers.contains(nearbyUser)) {
      pairedUsers.add(nearbyUser);
    }
  }

  Map<String, dynamic> ownedBooksData =
      ((await currentUserDocRef.get()).data() as Map<String, dynamic>);
  List<dynamic> ownedBooks = ownedBooksData['owns'];

  List<Book> usersBooks = await getUsersBooks(pairedUsers, ownedBooks);

/*
//Turn query to coordinates
const query = "Valbom";
List<Location> locations = await locationFromAddress(query);
logger.d('Latitude: ${locations.first.latitude}, Longitude: ${locations.first.longitude}');
*/
  return usersBooks;
}

void updateLocation(String? newLocation) async {
  if (newLocation == null) return;

  List<Location> location = await locationFromAddress(newLocation);
  final currentUser = FirebaseAuth.instance.currentUser;
  DocumentReference currentUserDocRef =
      await Queries.getUserDocRef(currentUser!.email);
  currentUserDocRef.update({
    "Location": GeoPoint(location.first.latitude, location.first.longitude),
  });
}
