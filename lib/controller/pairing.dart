import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pagepal/model/book.dart';
import 'package:pagepal/controller/queries.dart';
import 'package:pagepal/model/book_exchange.dart';

void processSwipeRight(
    Book book, BookExchange exchange, FirebaseFirestore db) async {
  if (exchange.bookExchangeCurrentAsReceiver != null) {
    //Found match
    exchange.bookExchangeCurrentAsReceiver?.delete();
    //TODO send message
  } else if (exchange.bookExchangeCurrentAsInitiator != null) {
    //Update exchange
    exchange.bookExchangeCurrentAsInitiator?.update({
      'receiverBooks':
          FieldValue.arrayUnion([await Queries.getBookDocRef(book.isbn)])
    });
  } else {
    //Create new exchange
    FirebaseFirestore.instance.collection('incompleteExchanges').add({
      'switchInitiator': exchange.curUser,
      'switchReceiver': exchange.otherUser,
      'receiverBooks': [await Queries.getBookDocRef(book.isbn)]
    });
  }
}
