import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pagepal/model/book.dart';
import 'package:pagepal/controller/queries.dart';
import 'package:pagepal/model/book_exchange.dart';
import 'package:pagepal/model/data/message.dart';
import 'package:pagepal/model/message.dart';

void processSwipeRight(
    Book book, BookExchange exchange, FirebaseFirestore db) async {
  if (exchange.bookExchangeCurrentAsReceiver != null) {
    //Found match
    // exchange.receiverBooks[0]  primeiro book que outro usuário disse que queria do nosso user
    // book.title                 book que curr user quer e pertence a outro
    //TODO send message
    Message message = Message(
        senderID: "/user/${exchange.otherUser.id}",
        recieverID: "/user/${exchange.curUser.id}",
        text: "[This is an automated message] I liked your book \"${exchange.receiverBooks[0].title}\" Want to trade?",
        date: Timestamp.now(),
        isRead: false);        
    sendMessage(message);

    message = Message(
        senderID: "/user/${exchange.curUser.id}",
        recieverID: "/user/${exchange.otherUser.id}",
        text: "[This is an automated message] I liked your book \"${book.title}\" Want to trade?",
        date: Timestamp.now(),
        isRead: false);        
    sendMessage(message);

    exchange.bookExchangeCurrentAsReceiver?.delete();

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
