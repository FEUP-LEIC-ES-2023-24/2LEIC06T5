import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pagepal/view/swipe/widgets/little_info_card.dart';

import '../../../model/book.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
  });
  final Book book;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFCCD5AE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Center(
            child: book.image,
          ),
          Align(
            alignment: const Alignment(0, 0.85),
            child: InfoCard(
              book: book,
            ),
          ),
        ],
      ),
    );
  }
}
