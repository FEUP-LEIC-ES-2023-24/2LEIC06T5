
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

bool isWithinDistance(double lat, double lon, double distance){
  
  /*TODo session get coordinates*/ double userLat = 0;
  /*TODo session get coordinates*/ double userLon = 0;
  return true;


}

Future<List<String>> getNearbyUsernames() async{
  /*Likely conect db diferently*/ FirebaseFirestore db = FirebaseFirestore.instance;
  /*TODo session getUsername*/ String username = "username_test"; 
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

void getNearbyUsersBooks() {
  List<String> NearbyUsernames = getNearbyUsernames();
  

}
//import 'package:geocoder/geocoder.dart'; PASSAR adress to coordinates

//import 'package:flutter_map_math/flutter_map_math.dart'; //MAP MATH
/*

----------Morada to coordenada----------
import 'package:geocoder/geocoder.dart';

final query = "1600 Amphiteatre Parkway, Mountain View";
var addresses = await Geocoder.local.findAddressesFromQuery(query);
var first = addresses.first;
print("${first.featureName} : ${first.coordinates}");

----------------------------------------
import 'package:geoflutterfire/geoflutterfire.dart';

Future<Map<String, dynamic>> getUserDataByUsername(String username) async {
  // Reference to the users collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Query for the user document with the specified username
  QuerySnapshot querySnapshot = await users.where('username', isEqualTo: username).get();

  // If a user with the given username exists, return their data
  if (querySnapshot.docs.isNotEmpty) {
    // Assuming username is unique, directly access the first document
    return querySnapshot.docs.first.data();
  } else {
    // Return null if no user with the given username is found
    return null;
  }
}

void queryNearbyUsers(string username) {

  String username = 'example_username'; //GET username info
  Map<String, dynamic> userData = await getUserDataByUsername(username);
    if (userData != null) {
      final center = GeoFirePoint(userData['latitude'],userData['longitude']); // GET USER STORED LOCATION

      // Make a query
      Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: FirebaseFirestore.instance.collection('users'))
        .within(center: center, radius: radius, field: 'location');
  } else {
    O QUE FAZER QUANDO NÂO SE ENCONTRA O USER
  }

*/