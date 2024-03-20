import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.color, required this.text});
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: color,
      child: Text(text),
    );
  }

}

class Example extends StatelessWidget {
  List<BookCard> cards = [
    const BookCard(color: Colors.blue, text: '1'),
    const BookCard(color: Colors.red, text: '2'),
    const BookCard(color: Colors.purple, text: '3'),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildMainPageBody(),
    );
  }

  Widget buildHeader() {
    return Container(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 10
                  ),
                  child: const Row(
                    children: [
                      Text("Location"),
                      Icon(Icons.add_circle),],
                  ),
              )
            ],
          ),
        )
    );
  }

  Widget buildSecondHeader() {
    return Container(
      child: SizedBox(
        height: 80,
        child: ListView(
          padding: const EdgeInsets.only(left: 15),
          children: const [
            Text("Discover",style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: Colors.green)),
            Row(
              children: [
                Icon(Icons.add),
                Text("Porto, Portugal")
              ])
          ],
        ),
      ),
    );
  }

  Widget buildMainBody() {
    return Column(
      children: [
        nah(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {},
                child: const Text('X')),
            ElevatedButton(
                onPressed: () {},
                child: const Text('V'))
          ],
        )
      ],
    );
  }

  Widget buildMainPageBody() {
    return ListView(
        children: [
          buildHeader(),
          buildSecondHeader(),
          buildMainBody(),
        ]
    );
  }

  Widget nah() {
    return SizedBox(
      height: 400,
      child: Flexible(
        child: CardSwiper(
          cardsCount: cards.length,
          cardBuilder: (context, index, percentThresholdX, percentThresholdY) => cards[index],
          duration: const Duration(milliseconds: 600),
        ),
      ),
    );
  }
}
