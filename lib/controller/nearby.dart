import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pagepal/model/book.dart';


double degreesToRadians(double degree){
  return degree * pi / 180.0;
}
Future<bool> isWithinDistance(double userLat, double userLon, double otherLat, double otherLon, double distance) async{


  otherLat = degreesToRadians(otherLat);
  otherLon = degreesToRadians(otherLon);
  userLat = degreesToRadians(userLat);
  userLon = degreesToRadians(userLon);

  double deltaLat = otherLat - userLat; 
  double deltaLon = otherLon - userLon;

  double aux = (sin(deltaLat/2) * sin(deltaLat/2)) + cos(otherLat) * cos(userLat) * (sin(deltaLon/2) * sin(deltaLon/2));
  double c = 2.0 * atan2(sqrt(aux), sqrt(1.0-aux));
  //earth radius: 6371000 meters
  return (c * 6371000) < distance;
}

Future<DocumentSnapshot> getCurrentUser() async{
  FirebaseFirestore db = FirebaseFirestore.instance;

  final User? user = FirebaseAuth.instance.currentUser;
  String? currentEmail = user?.email;
  QuerySnapshot usersRef = await db.collection('user').get();

  DocumentSnapshot loggedUserData = usersRef.docs.firstWhere((doc) => (doc.data() as Map<String, dynamic>)['email'] == currentEmail);
  return loggedUserData;
}

Future<DocumentReference> getUserDocRef(String? userEmail) async{
  FirebaseFirestore db = FirebaseFirestore.instance;
  QuerySnapshot querySnapshot = await db.collection('user').where('email',isEqualTo: userEmail).limit(1).get();
  DocumentReference userRef = querySnapshot.docs[0].reference;
  return userRef;
}


Future<List<DocumentReference>> getNearbyUsers() async{
  FirebaseFirestore db = FirebaseFirestore.instance;

  QuerySnapshot usersRef = await db.collection('user').get();

  Map<String,dynamic> loggedUserData = (await getCurrentUser()).data() as Map<String,dynamic>; 
  String currentEmail = loggedUserData['email'];


  GeoPoint originGeoPoint = loggedUserData['Location'];

  List<DocumentReference> allCloseUsers = [];
  
  for (DocumentSnapshot userDoc in usersRef.docs) {
    var userData = userDoc.data() as Map<String,dynamic>;
    GeoPoint geoPoint = userData['Location'];
      
    if ((userData['email'] != currentEmail) && (await isWithinDistance(originGeoPoint.latitude, originGeoPoint.longitude, geoPoint.latitude, geoPoint.longitude, 60))){
      allCloseUsers.add( (await getUserDocRef(userData['email']))); 
    }
  }
  return allCloseUsers;
}


Future<List<DocumentReference>> getPairedUsers(DocumentReference currentUser) async{
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<DocumentReference> pairedUsers = [];

  QuerySnapshot bookEchanges = await db.collection('bookEchange').where('switchReceiver', isEqualTo: currentUser).get();



  for (DocumentSnapshot bookEchange in bookEchanges.docs)
  {
    Map<String, dynamic> bookExchangeData = bookEchange.data() as Map<String,dynamic>;
    pairedUsers.add(bookExchangeData['switchIniciator']);

  }

  return pairedUsers;
}




Future<Book> getBookFromRef(DocumentReference bookRef) async{

  DocumentSnapshot<Map<String, dynamic>> bookData = await bookRef.get() as DocumentSnapshot<Map<String, dynamic>>;

  Book book = await Book.createBookFromFirestore(bookData);
  
  return book;

}

Future<List<Book>> filterBooks(Future<List<Book>> books )async{

  FirebaseFirestore db = FirebaseFirestore.instance;

  final User? user = FirebaseAuth.instance.currentUser;


  QuerySnapshot usersRef = await db.collection('user').get();
  QueryDocumentSnapshot loggedUserRef = usersRef.docs.firstWhere((doc) => (doc.data() as Map<String, dynamic>)['email'] == user?.email );
  List<String> loggedLikedGenres = loggedUserRef['likedGenres'];
  List<Book> allBooks = await books;
  List<Book> filterBooks = [];

  for (Book book in allBooks){
    for (String genre in book.genres){
  
      if (loggedLikedGenres.contains(genre)){
        filterBooks.add(book);
      }
    }
  }
  return filterBooks;
}


Future<List<Book>> getUsersBooks(List<DocumentReference> pairedUsers, DocumentReference currentUserDocRef) async{

  List<Book> pairedBooks = [];
  
  Map<String, dynamic> ownedBooksData = ((await currentUserDocRef.get()).data() as Map<String, dynamic>);
  List<dynamic> ownedBooks = ownedBooksData['owns'] as List<dynamic>;


  for (DocumentReference userRef in pairedUsers)
  {
    Map<String,dynamic> userData = (await userRef.get()).data() as Map<String,dynamic>;

    for (DocumentReference bookRef in userData['owns'])
    {
      bool isOwned = ownedBooks.any((ref) => ref == bookRef);
      if (!isOwned) {
        Book newBook =  await getBookFromRef(bookRef);
        newBook.ownerEmail = userData['email'];
        pairedBooks.add(newBook);
      }
    }
  }
  return pairedBooks;
}

Future<List<Book>> getNearbyUsersBooks() async{
  
  final User? currentUser = FirebaseAuth.instance.currentUser;
  DocumentReference currentUserDocRef = await getUserDocRef(currentUser?.email); 
  List<DocumentReference> pairedUsers = await getPairedUsers(currentUserDocRef);
  List<DocumentReference> nearbyUsers = await getNearbyUsers();
  for (DocumentReference nearbyUser in nearbyUsers)
  {
    if (!pairedUsers.contains(nearbyUser))
    {
      pairedUsers.add(nearbyUser);
    }
  }

  List<Book> usersBooks = await getUsersBooks(pairedUsers, currentUserDocRef);


/* //Turn query to coordinates
const query = "Valbom";
List<Location> locations = await locationFromAddress(query);
logger.d('Latitude: ${locations.first.latitude}, Longitude: ${locations.first.longitude}');
*/

return usersBooks;

}

//import 'package:geocoder/geocoder.dart'; PASSAR adress to coordinates
/*
----------Morada to coordenada----------
import 'package:geocoder/geocoder.dart';

final query = "1600 Amphiteatre Parkway, Mountain View";
var addresses = await Geocoder.local.findAddressesFromQuery(query);
var first = addresses.first;
print("${first.featureName} : ${first.coordinates}");

----------------------------------------*/