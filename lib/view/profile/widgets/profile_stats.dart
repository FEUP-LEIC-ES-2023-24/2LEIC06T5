import 'package:flutter/material.dart';

class ProfileStats extends StatefulWidget {
  const ProfileStats({super.key});

  @override
  State<StatefulWidget> createState() => ProfileStatsState();
}

class ProfileStatsState extends State {
  final int numMatches = 0;
  final int numStars = 4;
  final int numTrades = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(numMatches.toString()),
              const Text(
                'Matches',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Row(children: getStars(numStars)),
              const Text(
                'Rating',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(numTrades.toString()),
              const Text(
                'Trades',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        )
      ],
    );
  }

  List<Widget> getStars(int numStars) {
    List<Widget> stars = [];
    for (int i = 0; i < numStars; i++) {
      stars.add(const Icon(Icons.star));
    }
    for (int i = 0; i < 5 - numStars; i++) {
      stars.add(const Icon(Icons.star_border));
    }
    return stars;
  }
}
