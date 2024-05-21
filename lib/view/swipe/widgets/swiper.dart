import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:pagepal/controller/nearby.dart';
import 'package:pagepal/controller/pairing.dart';
import 'package:pagepal/controller/queries.dart';
import 'package:pagepal/model/bookExchange.dart';
import 'package:pagepal/view/swipe/widgets/book_card.dart';

import '../../../model/book.dart';

class Swiper extends StatelessWidget {
  const Swiper({super.key});

  Future<List<BookCard>> getBookCards() async {
    /*
    final bookFetcher = BooksFetcher();
    
    final firstBook = await bookFetcher.searchBookByISBN("0425038912");
    final secondBook = await bookFetcher.searchBookByISBN("1451673310");
    final thirdBook = await bookFetcher.searchBookByISBN("8401434645");
    */

    List<Book> books = await getNearbyUsersBooks();

    return createBookCards(books);
  }

  List<BookCard> createBookCards(List<Book> books) {
    return (books.map((book) => BookCard(book: book))).toList();
  }

  Future<bool> acceptChoice(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
    Book book,
  ) async {
    if (direction == CardSwiperDirection.right) {
      final User? user = FirebaseAuth.instance.currentUser;
      DocumentReference curUser = await Queries.getUserDocRef(user?.email);
      DocumentReference otherUser =
          await Queries.getUserDocRef(book.ownerEmail);
      DocumentReference? bookExchangeCurrentAsReceiver =
          await Queries.getIncompleBookExchange(otherUser, curUser);
      DocumentReference? bookExchangeCurrentAsInitiator =
          await Queries.getIncompleBookExchange(curUser, otherUser);
      List<Book> receiverBooks = await getUsersBooks([curUser], []);
      BookExchange exchange = BookExchange(
          curUser,
          otherUser,
          bookExchangeCurrentAsInitiator,
          bookExchangeCurrentAsReceiver,
          receiverBooks);
      FirebaseFirestore db = FirebaseFirestore.instance;
      processSwipeRight(book, exchange, db);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    CardSwiperController cardController = CardSwiperController();

    return FutureBuilder<List<BookCard>?>(
        future: getBookCards(),
        builder:
            (BuildContext context, AsyncSnapshot<List<BookCard>?> bookCards) {
          bookCards.data?.first.book;
          if (bookCards.hasData) {
            return Column(children: [
              SizedBox(
                height: 400,
                child: CardSwiper(
                  cardsCount: bookCards.data!.length,
                  cardBuilder:
                      (context, index, percentThresholdX, percentThresholdY) =>
                          bookCards.data?[index],
                  duration: const Duration(milliseconds: 200),
                  controller: cardController,
                  allowedSwipeDirection:
                      const AllowedSwipeDirection.only(right: true, left: true),
                  onSwipe: (int previousIndex, int? currentIndex,
                      CardSwiperDirection direction) {
                    return acceptChoice(previousIndex, currentIndex, direction,
                        bookCards.data![previousIndex].book);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButton(false, cardController),
                    buildButton(true, cardController)
                  ],
                ),
              )
            ]);
          } else if (bookCards.hasError) {
            return SizedBox(
              height: 400,
              child: Text('ERROR BOOK_CARDS: ${bookCards.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFCCD5AE),
              ),
            );
          }
        });
  }

  ElevatedButton buildButton(bool toRight, CardSwiperController controller) {
    return ElevatedButton(
        onPressed: () => controller.swipe(
            toRight ? CardSwiperDirection.right : CardSwiperDirection.left),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(10),
          backgroundColor: const Color(0xFFCCD5AE),
          foregroundColor: const Color(0xFFFEFAE0),
        ),
        child: Icon(
          toRight ? Icons.check : Icons.close,
          size: 50,
        ));
  }
}
