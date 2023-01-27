import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodz/constants.dart';
import 'package:foodz/views/restaurant/restaurant.claim.screen.dart';

class CreateBusinessItem extends StatelessWidget {
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
        child: Stack(
          children: [
            _buildCardContent(context, constraints),
            Positioned.fill(
                child: new Material(
                    color: Colors.transparent,
                    child: new InkWell(
                      highlightColor: Colors.white24,
                      splashColor: Colors.white24,
                      onTap: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RestaurantClaimScreen()))
                      },
                    )))
          ],
        ));
  }

  Widget _buildCardContent(BuildContext context, BoxConstraints constraints) {
    return Row(children: [
      SvgPicture.asset(CREATE_BUSINESS_ILLUSTRATION_ASSET,
          width: constraints.maxWidth * 0.5, height: 150, fit: BoxFit.fitWidth),
      SizedBox(width: 0.03 * constraints.maxWidth),
      SizedBox(
        width: 0.4 * constraints.maxWidth,
        child: Text(
          "Bring your restaurant's reach to the moon by creating a business profile!",
          maxLines: 6,
          textAlign: TextAlign.center,
        ),
      )
    ]);
  }
}
