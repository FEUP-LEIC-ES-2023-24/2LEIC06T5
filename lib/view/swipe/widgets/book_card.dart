import 'package:flutter/material.dart';
import 'package:pagepal/view/swipe/widgets/little_info_card.dart';

class BookCard extends StatelessWidget {
  const BookCard(
      {super.key,
      required this.color,
      required this.text,
      this.image = const AssetImage("assets/dune.jpg")});
  final Color color;
  final String text;
  final AssetImage image;

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
