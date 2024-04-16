import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:pagepal/model/book.dart';

double degreesToRadians(double degree){
  return degree * (pi / 180.0);
}

bool isWithinDistance(double lat, double lon, double distance){
  
  /*TODo session get coordinates*/ double userLat = 0;
  /*TODo session get coordinates*/ double userLon = 0;
  
  double dLat = degreesToRadians(lat-userLat); 
  double dLon = degreesToRadians(lon-userLon);

  double a = sin(dLat / 2) * sin(dLat / 2) + cos(degreesToRadians(userLat)) * cos(degreesToRadians(lat)) * sin(dLon / 2) * sin(lon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return c <= distance;

}

Future<List<String>> getNearbyUsernames() async{
  FirebaseFirestore db = FirebaseFirestore.instance;
  /*TODo session getUsername*/ String username = "janeDoe"; 
  List<String> allCloseUsernames = [];

  try {
    QuerySnapshot querySnapshot = await db.collection('user').get();

    for (var userDoc in querySnapshot.docs) {
      var userData = userDoc.data() as Map<String,dynamic>;
      if (isWithinDistance( userData['latitude'], userData['longitude'], 60) && username != userData['userName']) {
        allCloseUsernames.add(userData['userName']); 
      }
    }
  } catch  (e) {

    var logger = Logger();
    logger.d("Error in fetching all Users");
  }
  return allCloseUsernames;
}

Future<List<Book>> getSingleUserBooks(QueryDocumentSnapshot userDoc) async{

  List<Book> userBooks = [];

  List<DocumentReference> ownedBooks = (userDoc.data() as Map<String,dynamic>)['owns'];

  for (DocumentReference bookId in ownedBooks) {
    DocumentSnapshot bookSnapshot = await bookId.get();
    Book book = Book.fromFirestore(bookSnapshot.data() as DocumentSnapshot<Map<String, dynamic>>);
    userBooks.add(book);
  }

  return userBooks;
}

Future<List<Book>> filterBooks(Future<List<Book>> books )async{

  FirebaseFirestore db = FirebaseFirestore.instance;

  //TODO add SESSION get username
  String loggedUsername = 'janeDoe';

  QuerySnapshot usersRef = await db.collection('user').get();

  QueryDocumentSnapshot loggedUserRef = usersRef.docs.firstWhere((doc) => (doc.data() as Map<String, dynamic>)['userName'] == loggedUsername);
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



Future<List<Book>> getUsersBooks(Future<List<String>> nearbyUsernames) async{
  FirebaseFirestore db = FirebaseFirestore.instance;

  QuerySnapshot usersRef = await db.collection('user').get();
  List<Book> nearbyBooks = [];

  for (String otherUsername in await nearbyUsernames){
    QueryDocumentSnapshot otherUserRef = usersRef.docs.firstWhere((doc) => (doc.data() as Map<String, dynamic>)['userName'] == otherUsername);
    List<Book> singlNearbyBooks = await getSingleUserBooks(otherUserRef);
    for (Book book in singlNearbyBooks){
      nearbyBooks.add(book);
    }
  }
  return nearbyBooks;
}

Future<List<Book>> getNearbyUsersBooks() async{
  
  Future<List<String>> nearbyUsernames = getNearbyUsernames();

  Future<List<Book>> UsersBooks = getUsersBooks(nearbyUsernames);
  List<Book> filteredBooks = await filterBooks(UsersBooks);
  return filteredBooks;
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