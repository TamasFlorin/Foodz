import 'package:flutter/material.dart';

class Review {
  final String id;
  final String userId;
  final String content;
  final String reply;
  final double rating;
  final DateTime dateOfVisit;

  Review({
    @required this.id,
    @required this.userId,
    @required this.content,
    @required this.rating,
    @required this.dateOfVisit,
    this.reply,
  });

  static Review fromJson(Map<String, dynamic> json) {
    return Review(
        id: json["_id"],
        userId: json["userId"],
        content: json["content"],
        rating: json["rating"].toDouble(),
        dateOfVisit: DateTime.parse(json["dateOfVisit"]),
        reply: json.containsKey("reply") ? json["reply"] : null);
  }
}

class Reviews {
  final List<Review> reviews;
  Reviews({@required this.reviews});

  static Reviews fromJson(Map<String, dynamic> json) {
    return Reviews(
        reviews: json['reviews']
            .map<Review>((data) => Review.fromJson(data))
            .toList());
  }
}

class ReviewsWithHighlights {
  final List<Review> highlights;
  final List<Review> reviews;
  ReviewsWithHighlights({@required this.highlights, @required this.reviews});
}
