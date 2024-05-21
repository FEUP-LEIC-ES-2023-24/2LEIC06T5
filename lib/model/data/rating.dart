class Rating {
  final int num;
  final String ratedBookID;
  final String ratingUserID;
  final String text;

  Rating({
    required this.num,
    required this.ratedBookID,
    required this.ratingUserID,
    required this.text,
  });

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      num: map['num'],
      ratedBookID: map['ratedBookID'],
      ratingUserID: map['ratingUserID'],
      text: map['text'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'num': num,
      'ratedBookID': ratedBookID,
      'ratingUserID': ratingUserID,
      'text': text,
    };
  }
}
