import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodz/constants.dart';
import 'package:foodz/models/restaurant.model.dart';
import 'package:foodz/models/review.model.dart';
import 'package:foodz/services/review.service.dart';
import 'package:foodz/views/restaurant/fragments/restaurant.review.item.fragment.dart';

class RestaurantPendingReviewsFragment extends StatefulWidget {
  final Restaurant restaurant;
  final Function onUpdateList;
  RestaurantPendingReviewsFragment(
      {@required this.restaurant, this.onUpdateList, Key key})
      : super(key: key);

  @override
  _RestaurantPendingReviewsFragmentState createState() =>
      _RestaurantPendingReviewsFragmentState();
}

class _RestaurantPendingReviewsFragmentState
    extends State<RestaurantPendingReviewsFragment> {
  static const _itemsPerPage = 10;
  PagewiseLoadController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PagewiseLoadController(
        pageFuture: (val) => _getPendingReviews(val), pageSize: _itemsPerPage);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) =>
            _getPendingReviewsList(context, constraints));
  }

  Widget _getPendingReviewsList(
      BuildContext context, BoxConstraints constraints) {
    final additionalItems = [
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text('Pending Reviews',
            style: Theme.of(context).textTheme.subtitle1),
      )
    ];

    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () async {
        _pageController.reset();
        if (widget.onUpdateList != null) {
          widget.onUpdateList();
        }
        await Future.value({});
      },
      child: PagewiseListView(
          shrinkWrap: true,
          pageLoadController: _pageController,
          itemBuilder: (context, review, itemIndex) {
            final reviewFragment = ReviewItemFragment(
              review: review,
              restaurant: widget.restaurant,
            );
            if (itemIndex == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [...additionalItems, reviewFragment],
              );
            }
            return reviewFragment;
          },
          loadingBuilder: (context) {
            return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                backgroundColor: Theme.of(context).primaryColor);
          },
          noItemsFoundBuilder: (context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('No pending reviews! Well done!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1),
                SizedBox(height: 30),
                SvgPicture.asset(
                  NO_PENDING_REVIEWS_ILLUSTRATION_ASSET,
                  fit: BoxFit.fitWidth,
                  width: 0.5 * constraints.maxWidth,
                  height: 0.5 * constraints.maxHeight,
                ),
              ],
            );
          }),
    );
  }

  Future<List<Review>> _getPendingReviews(int pageNumber) async {
    final reviews = await ReviewService().getPending(
        restaurantId: widget.restaurant.id,
        pageNumber: pageNumber,
        itemsPerPage: _itemsPerPage);

    return reviews;
  }
}
