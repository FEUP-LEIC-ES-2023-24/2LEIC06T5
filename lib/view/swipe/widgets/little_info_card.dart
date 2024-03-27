import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 230,
        height: 80,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dune',
                  style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFCCD5AE),
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Frank Herbert',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF949494)),
                )
              ],
            ),
            Icon(
              Icons.info_outline,
              color: Color(0xFFCCD5AE),
            )
          ],
        ),
      ),
    );
  }
}
