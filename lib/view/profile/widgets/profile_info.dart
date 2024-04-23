import 'package:flutter/material.dart';

class ProfileInfo {
  ProfileInfo(this.username, this.userTitle, this.location, this.numMatches,
      this.numStars, this.numTrades);

  final String username;
  final String userTitle;
  final String location;

  final int numMatches;
  final int numStars;
  final int numTrades;

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

  Widget getProfileInfo() {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Text(
                  username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  userTitle,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                Text(
                  location,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                )
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget getProfileStats() {
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
}
