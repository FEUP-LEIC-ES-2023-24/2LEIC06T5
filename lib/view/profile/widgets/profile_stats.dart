import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pagepal/controller/queries.dart';

class ProfileStats extends StatefulWidget {
  const ProfileStats({super.key});

  @override
  State<StatefulWidget> createState() => ProfileStatsState();
}

class ProfileStatsState extends State {
  final int numMatches = 0;
  int numStars = 0;
  final int numTrades = 0;

  @override
  void initState() {
    super.initState();
    initializeRating();
  }

  Future<void> initializeRating() async {
    final rating =
        await Queries.getRating(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      numStars = rating.rating.round();
    });
  }

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
