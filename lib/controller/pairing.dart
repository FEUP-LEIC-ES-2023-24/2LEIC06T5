import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pagepal/model/book.dart';
import 'package:pagepal/controller/queries.dart';


void processSwipeRight(Book book) async {
  final User? user = FirebaseAuth.instance.currentUser;

  DocumentReference currentUserRef  = await Queries.getUserDocRef(user?.email);
  DocumentReference otherUserRef    = await Queries.getUserDocRef(book.ownerEmail);

  DocumentReference? bookExchangeCurrentReceiver  = await Queries.getbookExchange(otherUserRef  , currentUserRef);
  DocumentReference? bookExchangeCurrentInitiator = await Queries.getbookExchange(currentUserRef, otherUserRef);
  

  if(bookExchangeCurrentReceiver != null)
  {
    //FOUND match

  } else if (bookExchangeCurrentInitiator != null){
    //Update exchange
      bookExchangeCurrentInitiator.update({'receiverBooks': FieldValue.arrayUnion([await Queries.getBookDocRef(book.isbn)])});
  }else{
    //Create new exchange
    FirebaseFirestore.instance.collection('incompleteExchanges').add({
      'switchInitiator' :currentUserRef,
      'switchReceiver'  :otherUserRef,
      'receiverBooks'   :[await Queries.getBookDocRef(book.isbn)]
    });
  }
}