import 'package:flutter/material.dart';
import 'package:pagepal/controller/queries.dart';
import 'package:pagepal/model/rating.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key, required this.userID});
  final String userID;

  @override
  State<StatefulWidget> createState() => RatingDialogState();
}

class RatingDialogState extends State<RatingDialog> {
  int numStars = 0;
  Rating rating = Rating(rating: 0, size: 0);

  @override
  void initState() {
    super.initState();
    initializeRating();
  }

  Future<void> initializeRating() async {
    final newRating = await Queries.getRating(widget.userID);
    setState(() {
      rating = newRating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      content: Row(children: getStars(numStars)),
      actions: [
        ElevatedButton(
            onPressed: () => {
                  Queries.updateRating(widget.userID, rating, numStars),
                  Navigator.of(context).pop()
                },
            child: const Text('Confirm'))
      ],
    );
  }

  List<Widget> getStars(int numStars) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      stars.add(getStarButton(i, i < numStars));
    }
    return stars;
  }

  Widget getStarButton(int starIndex, bool selected) {
    return IconButton(
        onPressed: () => {
              setState(() {
                numStars = starIndex + 1;
              })
            },
        icon:
            selected ? const Icon(Icons.star) : const Icon(Icons.star_border));
  }
}
