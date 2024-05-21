import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pagepal/model/book.dart';

class BookExchange {
  BookExchange(
      this.curUser,
      this.otherUser,
      this.bookExchangeCurrentAsInitiator,
      this.bookExchangeCurrentAsReceiver,
      this.receiverBooks);

  DocumentReference? bookExchangeCurrentAsReceiver;
  DocumentReference? bookExchangeCurrentAsInitiator;
  final DocumentReference curUser;
  final DocumentReference otherUser;
  List<Book> receiverBooks;
}
