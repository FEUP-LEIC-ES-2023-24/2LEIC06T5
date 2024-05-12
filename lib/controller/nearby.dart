import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
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

Future<List<Map<String,dynamic>>> getNearbyUsers() async{
  FirebaseFirestore db = FirebaseFirestore.instance;

  final User? user = FirebaseAuth.instance.currentUser;
  String? currentEmail = user?.email;

  QuerySnapshot usersRef = await db.collection('user').get();

  //QueryDocumentSnapshot loggedUserData = await getCurrentUser(); 

  //GeoPoint originGeoPoint = loggedUserData['location'];

  List<Map<String,dynamic>> allCloseUsers = [];
  for (DocumentSnapshot userDoc in usersRef.docs) {
    var userData = userDoc.data() as Map<String,dynamic>;
    /*
    GeoPoint geoPoint = userData['location'];
      
    if ((userData['email'] != currentEmail) && (await isWithinDistance(originGeoPoint.latitude, originGeoPoint.longitude, geoPoint.latitude, geoPoint.longitude, 60))){
      allCloseUsers.add(userData); 
    }
    */

    if ((userData['email'] != currentEmail)){
      allCloseUsers.add(userData); 
    }
  }
  return allCloseUsers;
}

/*
Future<List<Map<String,dynamic>>> getPairedUsers() async{
  FirebaseFirestore db = FirebaseFirestore.instance;

  final User? user = FirebaseAuth.instance.currentUser;
  String? currentEmail = user?.email;
  QuerySnapshot usersRef = await db.collection('bookExchange').get();

  QueryDocumentSnapshot loggedUserData = await getCurrentUser(); 


}
*/



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


Future<List<Book>> getUsersBooks(List<Map<String,dynamic>> nearbyUsers) async{

  List<Book> nearbyBooks = [];
  DocumentSnapshot currentUserData = await getCurrentUser();

  List<dynamic> ownedBooks = (currentUserData['owns'] as List<dynamic>);
  
  for (Map<String,dynamic> userRef in nearbyUsers)
  {
    for (DocumentReference bookRef in userRef['owns'])
    {
      bool isOwned = ownedBooks.any((ref) => ref.path == bookRef.path);
      if (!isOwned) {

        nearbyBooks.add( await getBookFromRef(bookRef) );
        Logger logger = Logger();
        logger.d(bookRef.toString());
      }
    }
  }
  return nearbyBooks;
}

Future<List<Book>> getNearbyUsersBooks() async{
  
  List<Map<String,dynamic>> nearbyUsers = await getNearbyUsers();
  //List<Map<String,dynamic>> pairedUsers = await getPairedUsers();

  List<Book> usersBooks = await getUsersBooks(nearbyUsers);

  for (Book b in usersBooks)
  {
    Logger logger = Logger();
    logger.d(b.mainAuthor);
  }

  return usersBooks;

/*
Logger logger = Logger();
const query = "Rua Buarcos 71, Valbom Gondomar";
List<Location> locations = await locationFromAddress(query);
logger.d('Latitude: ${locations.first.latitude}, Longitude: ${locations.first.longitude}');
*/

  //Future<List<Book>> UsersBooks = getUsersBooks(nearbyUsernames);
  /*
  Future<List<Book>> UsersBooks = getUsersBooks(nearbyUsernames);
  List<Book> filteredBooks = await filterBooks(UsersBooks);
  */
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