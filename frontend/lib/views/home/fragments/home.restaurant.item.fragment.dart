import 'package:flutter/material.dart';
import 'package:foodz/models/restaurant.model.dart';
import 'package:foodz/views/restaurant/restaurant.details.screen.dart';

class RestaurantItem extends StatelessWidget {
  final Restaurant restaurant;
  RestaurantItem({this.restaurant});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => _build(context, constraints));
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    return Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0, bottom: 10.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        child: Stack(children: [
          _buildCardContent(context, constraints),
          Positioned.fill(
              child: new Material(
                  color: Colors.transparent,
                  child: new InkWell(
                    highlightColor: Colors.white24,
                    splashColor: Colors.white24,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RestaurantDetailsScreen(
                              restaurant: this.restaurant)));
                    },
                  ))),
        ]));
  }

  Widget _buildCardContent(BuildContext context, BoxConstraints constraints) {
    return Column(
      children: [
        Padding(
            //padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0),
            padding: EdgeInsets.zero,
            child: Image.asset(
              'assets/business_cover.jpg',
              height: 150,
              width: constraints.maxWidth,
              fit: BoxFit.fitWidth,
            )),
        ListTile(
          title: Text('${this.restaurant.name}',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 0.7 * constraints.maxWidth,
                child: Text(
                  '${this.restaurant.address}',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star_rounded, color: Colors.yellow[600]),
                  SizedBox(width: 2),
                  Text('${restaurant.averageRating.toStringAsFixed(1)}')
                ],
              )
            ],
          ),
        ),
        //Image.asset('assets/card-sample-image-2.jpg'),
      ],
    );
  }
}
