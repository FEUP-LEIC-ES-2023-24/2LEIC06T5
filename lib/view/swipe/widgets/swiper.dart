import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:pagepal/view/swipe/widgets/book_card.dart';

class Swiper extends StatelessWidget {
  Swiper({super.key});

  final List<BookCard> cards = [
    const BookCard(color: Colors.black, text: 'teste'),
    const BookCard(color: Colors.blue, text: 'teste2'),
    const BookCard(color: Colors.green, text: 'teste3')
  ];

  FutureOr<bool> acceptChoice(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    // TODO: DO SOMETHING GIVEN THE DIRECTION OF THE SWIPE
    return false;
  }

  @override
  Widget build(BuildContext context) {
    CardSwiperController cardController = CardSwiperController();
    return Column(children: [
      SizedBox(
        height: 400,
        child: CardSwiper(
          cardsCount: cards.length,
          cardBuilder: (context, index, percentThresholdX, percentThresholdY) =>
              cards[index],
          duration: const Duration(milliseconds: 200),
          controller: cardController,
          allowedSwipeDirection:
              const AllowedSwipeDirection.only(right: true, left: true),
          onSwipe: acceptChoice,
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
