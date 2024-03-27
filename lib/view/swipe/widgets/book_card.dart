import 'package:flutter/material.dart';
import 'package:pagepal/view/swipe/widgets/little_info_card.dart';

class BookCard extends StatelessWidget {
  const BookCard(
      {super.key,
      required this.color,
      required this.text,
      this.image = const NetworkImage(
          'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1555447414i/44767458.jpg')});
  final Color color;
  final String text;
  final NetworkImage image;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Center(
            child: Image(image: image),
          ),
          const Align(
            alignment: Alignment(0, 0.85),
            child: InfoCard(),
          ),
        ],
      ),
    );
  }
}
