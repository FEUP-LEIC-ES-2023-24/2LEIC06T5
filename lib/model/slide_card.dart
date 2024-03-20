import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/material.dart';

// TODO: THIS NEEDS TO BE IN A DIFFERENT FILE
class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.color, required this.text});
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20)
      ),
      // TODO: MAKE IMAGE FILL THE WHOLE CARD
      child: Stack(children: [
        const Center(child: Image(
        image: NetworkImage('https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1555447414i/44767458.jpg'),)),
        Align(
          alignment: const Alignment(0.0,0.8),
          child: InfoCard(),
      )])
    );
  }

}

// TODO: THIS ALSO NEEDS TO BE IN A DIFFERENT FILE
class InfoCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          width: 200,
          height: 60,
          child: Container(
            padding: EdgeInsets.all(5),
            child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dune',style: TextStyle(fontSize: 20,color:Color(0xFFCCD5AE),fontWeight: FontWeight.bold),),
                  Text('Frank Herbert', style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF949494)),)
                ],
              ),
              // TODO: CHANGE ICON
              Icon(Icons.info_outline,color: Color(0xFFCCD5AE),)
            ],
          ),)
        ),
      ),
    );
  }

}

class SlideCard extends StatefulWidget {
  const SlideCard({super.key});

  @override
  State<StatefulWidget> createState() => _SlideCardState();
}

// TODO: THIS NEEDS TO DEPEND ON THE DATABASE
class _SlideCardState extends State<SlideCard> {
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
                      Text("Location ",style: TextStyle(color: Colors.black),),
                      Icon(Icons.add_circle,color: Colors.black,),],
                  ),
              )
            ],
          ),
        )
    );
  }

  Widget buildSecondHeader() {
    return SizedBox(
      height: 80,
      child: ListView(
        padding: const EdgeInsets.only(left: 15),
        children: const [
          Text("Discover",style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: Color(0xFFCCD5AE))),
          Row(
            children: [
              Icon(Icons.add),
              // TODO: THIS IS HARDCODED
              Text("Porto, Portugal")
            ])
        ],
      ),
    );
  }

  Widget buildMainBody() {
    return Column(
      children: [
        nah()
      ],
    );
  }

  Widget buildMainPageBody() {
    return ListView(
        // TODO: NEEDS COMPARTIBILIZATION
        children: [
          buildHeader(),
          buildSecondHeader(),
          buildMainBody(),
        ]
    );
  }

  Widget nah() {
    CardSwiperController cardController = CardSwiperController();
    return Column(
        children: [SizedBox(
      height: 450,
      child: Flexible(
        child: CardSwiper(
          cardsCount: cards.length,
          cardBuilder: (context, index, percentThresholdX, percentThresholdY) => cards[index],
          duration: const Duration(milliseconds: 200),
          controller: cardController,
        ),
      ),
    ),
          // TODO: THIS IS JUST DUMB
          Container(
            padding: EdgeInsets.only(top: 10),
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {cardController.swipe(CardSwiperDirection.left);},
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.all(10),
                    backgroundColor: Color(0xFFCCD5AE),
                    foregroundColor: Color(0xFFFEFAE0),
                  ),

                  child: const Icon(Icons.close,size: 50,),),
                ElevatedButton(
                  onPressed: () {cardController.swipe(CardSwiperDirection.right);},
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Color(0xFFCCD5AE),
                      foregroundColor: Color(0xFFFEFAE0),
                      padding: const EdgeInsets.all(10)
                  ),
                  child: const Icon(Icons.check,size: 50,),),
              ],
            ),
          )
]
    );
  }
}
