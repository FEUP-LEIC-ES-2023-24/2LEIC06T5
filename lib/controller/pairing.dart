import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pagepal/model/book.dart';
import 'package:pagepal/controller/queries.dart';

void processSwipeRight(Book book) async {
  final User? user = FirebaseAuth.instance.currentUser;

  DocumentReference currentUserRef = await Queries.getUserDocRef(user?.email);
  DocumentReference otherUserRef = await Queries.getUserDocRef(book.ownerEmail);

  DocumentReference? bookExchangeCurrentReceiver =
      await Queries.getIncompleBookExchange(otherUserRef, currentUserRef);
  DocumentReference? bookExchangeCurrentInitiator =
      await Queries.getIncompleBookExchange(currentUserRef, otherUserRef);

  if (bookExchangeCurrentReceiver != null) {
    //Found match
    DocumentSnapshot bookExchangeSnapshot =
        await bookExchangeCurrentReceiver.get();
    Map<String, dynamic> bookExchangeData =
        bookExchangeSnapshot.data() as Map<String, dynamic>;

    FirebaseFirestore.instance.collection("idleExchanges").add({
      'user1': currentUserRef,
      'book1': bookExchangeData['receiverBooks'][0],
      'user2': otherUserRef,
      'book2': await Queries.getBookDocRef(book.isbn),
    });
    bookExchangeCurrentReceiver.delete();
    //TODO send message
  } else if (bookExchangeCurrentInitiator != null) {
    //Update exchange
    bookExchangeCurrentInitiator.update({
      'receiverBooks':
          FieldValue.arrayUnion([await Queries.getBookDocRef(book.isbn)])
    });
  } else {
    //Create new exchange
    FirebaseFirestore.instance.collection('incompleteExchanges').add({
      'switchInitiator': currentUserRef,
      'switchReceiver': otherUserRef,
      'receiverBooks': [await Queries.getBookDocRef(book.isbn)]
    });
  }
}
