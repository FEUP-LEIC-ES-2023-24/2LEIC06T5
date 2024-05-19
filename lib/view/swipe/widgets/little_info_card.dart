import 'package:flutter/material.dart';
import 'package:pagepal/model/book.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.book});
  final Book book;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Opacity(
        opacity: 1,
        child: Container(
          width: 230,
          height: 80,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      book.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFFCCD5AE),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      book.mainAuthor,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF949494)),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: const Icon(
                  Icons.info_outline,
                  color: Color(0xFFCCD5AE),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
