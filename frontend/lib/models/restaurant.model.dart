import 'package:flutter/material.dart';

class Restaurant {
  final String id;
  final String ownerId;
  final String name;
  final String address;
  final double averageRating;

  Restaurant(
      {@required this.name,
      @required this.address,
      @required this.ownerId,
      @required this.averageRating,
      @required this.id});

  static Restaurant fromJson(Map<String, dynamic> json) {
    return Restaurant(
        name: json["name"],
        address: json["address"],
        ownerId: json["ownerId"],
        averageRating: json["averageRating"].toDouble(),
        id: json["_id"]);
  }
}

class Restaurants {
  final List<Restaurant> restaurants;
  Restaurants({@required this.restaurants});

  static Restaurants fromJson(Map<String, dynamic> json) {
    return Restaurants(
        restaurants: json['restaurants']
            .map<Restaurant>((data) => Restaurant.fromJson(data))
            .toList());
  }
}
